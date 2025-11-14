FROM nvidia/cuda:12.1.0-cudnn8-runtime-ubuntu22.04

WORKDIR /workspace

# Install system dependencies
RUN apt-get update && apt-get install -y \
    python3 python3-pip git wget curl ffmpeg libgl1 libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

# Install PyTorch CUDA 12.1
RUN pip install --upgrade pip && \
    pip install torch==2.1.2 torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121

# Fix NumPy incompatibility with Torch 2.1.2 (Force numpy <2)
RUN pip install "numpy<2"

# Clone ComfyUI
RUN git clone https://github.com/comfyanonymous/ComfyUI.git /workspace/ComfyUI

# Install ComfyUI deps
RUN pip install -r /workspace/ComfyUI/requirements.txt

# Copy scripts
COPY start.sh /workspace/start.sh
COPY serverless.py /workspace/serverless.py
COPY install-models.sh /workspace/install-models.sh
RUN chmod +x /workspace/start.sh /workspace/install-models.sh

# Install custom nodes
RUN mkdir -p /workspace/ComfyUI/custom_nodes && \
    cd /workspace/ComfyUI/custom_nodes && \
    git clone https://github.com/kijai/ComfyUI-WanVideoWrapper.git && \
    git clone https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite.git && \
    git clone https://github.com/kijai/ComfyUI-WanAnimatePreprocess.git && \
    git clone https://github.com/kijai/ComfyUI-KJNodes.git

# Model directory
RUN mkdir -p /workspace/models

ARG SKIP_MODEL_DOWNLOAD=0
RUN if [ "$SKIP_MODEL_DOWNLOAD" = "0" ]; then /workspace/install-models.sh; fi

# Env for RunPod
ENV RUNPOD_MODE=SERVERLESS

CMD ["/workspace/start.sh"]
