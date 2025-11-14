FROM nvidia/cuda:12.1.0-cudnn8-runtime-ubuntu22.04

WORKDIR /workspace

# ---------------------------------------------------------------------
# System dependencies
# ---------------------------------------------------------------------
RUN apt-get update && apt-get install -y \
    python3 python3-pip git wget curl ffmpeg libgl1 libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

# ---------------------------------------------------------------------
# Install CUDA 12.1 compatible PyTorch stack (MUST USE THESE VERSIONS)
# ---------------------------------------------------------------------
RUN pip install --upgrade pip && \
    pip install \
        torch==2.1.1+cu121 \
        torchvision==0.16.1+cu121 \
        torchaudio==2.1.1+cu121 \
        --index-url https://download.pytorch.org/whl/cu121

# ---------------------------------------------------------------------
# Stable dependencies for ComfyUI + custom nodes
# ---------------------------------------------------------------------
RUN pip install \
    "transformers==4.31.0" \
    "diffusers==0.21.0" \
    "accelerate==0.25.0" \
    "numpy<2" \
    "requests"

# ---------------------------------------------------------------------
# Clone ComfyUI
# ---------------------------------------------------------------------
RUN git clone https://github.com/comfyanonymous/ComfyUI.git /workspace/ComfyUI

# Install ComfyUI requirements
RUN pip install -r /workspace/ComfyUI/requirements.txt || true

# ---------------------------------------------------------------------
# Custom nodes
# ---------------------------------------------------------------------
RUN mkdir -p /workspace/ComfyUI/custom_nodes && \
    cd /workspace/ComfyUI/custom_nodes && \
    git clone https://github.com/kijai/ComfyUI-WanVideoWrapper.git && \
    git clone https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite.git && \
    git clone https://github.com/kijai/ComfyUI-WanAnimatePreprocess.git && \
    git clone https://github.com/kijai/ComfyUI-KJNodes.git

# ---------------------------------------------------------------------
# FIX: Force reinstall stable versions (custom nodes overwrite this)
# ---------------------------------------------------------------------
RUN pip uninstall -y transformers diffusers accelerate && \
    pip install \
        "transformers==4.31.0" \
        "diffusers==0.21.0" \
        "accelerate==0.25.0" \
        "numpy<2"

# ---------------------------------------------------------------------
# Install RunPod Serverless SDK
# ---------------------------------------------------------------------
RUN pip install runpod

# ---------------------------------------------------------------------
# Add runtime scripts
# ---------------------------------------------------------------------
COPY start.sh /workspace/start.sh
COPY rp_handler.py /workspace/rp_handler.py
COPY serverless_comfy_runner.py /workspace/serverless_comfy_runner.py
COPY install-models.sh /workspace/install-models.sh

RUN chmod +x /workspace/*.sh

# ---------------------------------------------------------------------
# Model directory
# ---------------------------------------------------------------------
RUN mkdir -p /workspace/models

ARG SKIP_MODEL_DOWNLOAD=0
RUN if [ "$SKIP_MODEL_DOWNLOAD" = "0" ]; then bash /workspace/install-models.sh; fi

ENV RUNPOD_MODE=SERVERLESS

CMD ["bash", "/workspace/start.sh"]
