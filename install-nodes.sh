#!/usr/bin/env bash
set -e

NODES_DIR="/workspace/ComfyUI/custom_nodes"

mkdir -p "$NODES_DIR"
cd "$NODES_DIR"

echo "[nodes] Installing custom nodes..."

# ----------------------------------------------------
# 1) WAN Video Wrapper (WAJIB)
# ----------------------------------------------------
if [ ! -d "ComfyUI-WanVideoWrapper" ]; then
  echo "[nodes] Installing WAN Video Wrapper..."
  git clone https://github.com/kijai/ComfyUI-WanVideoWrapper.git
fi

# ----------------------------------------------------
# 2) SAM2 (Segment Anything 2) — PUBLIC repo
# ----------------------------------------------------
if [ ! -d "ComfyUI-SAM2" ]; then
  echo "[nodes] Installing SAM2..."
  git clone https://github.com/ltdrdata/ComfyUI-SAM2.git
fi

# ----------------------------------------------------
# 3) Video Helper Suite (RIFE, interpolation, encoding) — PUBLIC
# ----------------------------------------------------
if [ ! -d "ComfyUI-Video-Helper-Suite" ]; then
  echo "[nodes] Installing Video Helper Suite..."
  git clone https://github.com/Kosinkadink/ComfyUI-Video-Helper-Suite.git
fi

echo "[nodes] Custom nodes installed successfully!"
