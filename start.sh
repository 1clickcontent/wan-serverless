#!/usr/bin/env bash
set -e
WORKDIR=/workspace

echo "[start] Ensure models exist"
if [ -f /workspace/install-models.sh ]; then
  if [ "${SKIP_MODEL_DOWNLOAD:-0}" = "0" ]; then
    echo "[start] running install-models.sh"
    /workspace/install-models.sh || echo "install-models failed (continuing...)"
  else
    echo "[start] SKIP_MODEL_DOWNLOAD=1, skipping model download"
  fi
fi

export COMFY_CUSTOM_NODE_DIR=/workspace/ComfyUI/custom_nodes
export COMFY_MODELS_DIR=/workspace/models

echo "[start] Starting ComfyUI serverless runner"
python3 /workspace/serverless.py
