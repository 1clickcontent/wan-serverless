#!/usr/bin/env bash
set -e

cd /workspace/ComfyUI/custom_nodes || mkdir -p /workspace/ComfyUI/custom_nodes && cd /workspace/ComfyUI/custom_nodes

echo "[nodes] Installing custom nodes..."

# WAN video wrapper (your existing)
if [ ! -d "ComfyUI-WanVideoWrapper" ]; then
  git clone https://github.com/kijai/ComfyUI-WanVideoWrapper.git
fi

# SAM2 (Segment Anything 2) node (example repo, adjust if different)
if [ ! -d "ComfyUI-SAM2" ]; then
  git clone https://github.com/ltdrdata/ComfyUI-SAM2.git
fi

# DWpose node (pose->video helper)
if [ ! -d "ComfyUI-DWpose" ]; then
  git clone https://github.com/justinjohn0306/ComfyUI-DWpose.git || echo "DWpose clone may be unavailable; please add manually"
fi

# RIFE VFI / vidhub nodes (interpolation)
if [ ! -d "ComfyUI-RIFE" ]; then
  git clone https://github.com/BlurryGG/ComfyUI-RIFE.git || echo "RIFE clone failed, add manually"
fi

# VHS / video helpers
if [ ! -d "ComfyUI-VideoNodes" ]; then
  git clone https://github.com/k00k/vhs-comfyui.git || echo "vhs-comfyui clone failed"
fi

# Any other custom nodes you need, append clones here
echo "[nodes] Done installing custom nodes."
