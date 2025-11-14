# Dockerfile - COMFYUI + WAN + SAM2 + DWpose + RIFE + SDXL (targets 48GB+ GPUs)
# WARNING: image will be large when you include models/

FROM nvidia/cuda:12.1.0-cudnn8-runtime-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /workspace

# -------------------------
# System deps
# -------------------------
RUN apt-get update && apt-get install -y \
    git python3 python3-pip python3-dev ffmpeg wget curl build-essential ca-certificates \
    libgl1 libglib2.0-0 libsm6 libxext6 pkg-config \
    && rm -rf /var/lib/apt/lists/*

# upgrade pip
RUN python3 -m pip install --upgrade pip setuptools wheel

# -------------------------
# PyTorch / Torchvision / Torchaudio (CUDA 12.1)
# Use official wheels from pytorch index.
# -------------------------
RUN pip install --no-cache-dir \
    "torch>=2.4.0" "torchvision" "torchaudio" --index-url https://download.pytorch.org/whl/cu121

# -------------------------
# Clone ComfyUI
# -------------------------
RUN git clone https://github.com/comfyanonymous/ComfyUI.git /workspace/ComfyUI

# Install ComfyUI requirements (we will override any problematic packages later)
RUN pip install --no-cache-dir -r /workspace/ComfyUI/requirements.txt

# -------------------------
# Install / force compatible transformers (avoid pytree register error)
# pinned to safe version
# -------------------------
RUN pip install --no-cache-dir "transformers==4.35.2" "diffusers>=0.20.0" "accelerate" "safetensors" "onnxruntime-gpu" "opencv-python-headless" "imageio[ffmpeg]" "tqdm" "einops" "ftfy"

# Optional: install xformers if you want (skip if build fails or too heavy)
# RUN pip install --no-cache-dir xformers

# -------------------------
# Custom nodes (WAN, SAM2, DWpose, RIFE, VHS, etc)
# -------------------------
COPY install-nodes.sh /workspace/install-nodes.sh
RUN chmod +x /workspace/install-nodes.sh && /workspace/install-nodes.sh

# -------------------------
# Copy included models if you put them in build context ./models
# (Opsi A: user places models/ before build)
# -------------------------
# If ./models exists in build context it will be copied into image.
COPY models /workspace/models

# Optional: run install-models.sh to fetch any missing models (slow)
COPY install-models.sh /workspace/install-models.sh
RUN chmod +x /workspace/install-models.sh && /workspace/install-models.sh || echo "install-models.sh exited (continue)"

# -------------------------
# Copy serverless handler
# -------------------------
COPY serverless.py /workspace/serverless.py
RUN chmod +x /workspace/serverless.py

EXPOSE 8188

# Run serverless handler (it will launch ComfyUI then run the handler)
CMD ["python3", "/workspace/serverless.py"]
