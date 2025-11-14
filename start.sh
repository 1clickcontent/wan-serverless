#!/usr/bin/env bash
set -e

echo "[start] Ensure models installed"
bash /workspace/install-models.sh || echo "Model install skipped or failed"

export COMFY_CUSTOM_NODE_DIR=/workspace/ComfyUI/custom_nodes
export COMFY_MODELS_DIR=/workspace/models

echo "[start] Starting ComfyUI (background)..."
python3 /workspace/serverless_comfy_runner.py &

echo "[start] Waiting 3 seconds before starting handler..."
sleep 3

echo "[start] Starting RunPod handler..."
python3 /workspace/rp_handler.py
