#!/usr/bin/env bash
set -e

echo "[start] Installing/ensuring models..."
bash /workspace/install-models.sh || echo "model install skipped"

export COMFY_CUSTOM_NODE_DIR=/workspace/ComfyUI/custom_nodes
export COMFY_MODELS_DIR=/workspace/models

echo "[start] Starting ComfyUI in background..."
python3 /workspace/serverless_comfy_runner.py &

sleep 3
echo "[start] Starting RunPod serverless handler..."
python3 /workspace/rp_handler.py
