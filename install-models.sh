#!/usr/bin/env bash

echo "[install-models] start"

mkdir -p /workspace/models/checkpoints
mkdir -p /workspace/models/safetensors
mkdir -p /workspace/models/onnx

# You can add:
# wget https://huggingface.co/... -O /workspace/models/checkpoints/model.safetensors

echo "[install-models] done. list:"
ls -lah /workspace/models
