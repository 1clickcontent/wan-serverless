#!/usr/bin/env bash
set -e
WORKDIR=/workspace
MODELS_DIR=$WORKDIR/models
HF_TOKEN=${HUGGINGFACE_TOKEN:-""}

echo "[install-models] start"

# helper to download from HF with token
hf_download() {
  local url="$1"
  local out="$2"
  if [ -z "$HF_TOKEN" ]; then
    echo "No HUGGINGFACE_TOKEN set — attempting anonymous download for $url"
    curl -L -o "$out" "$url"
  else
    echo "Downloading with HUGGINGFACE_TOKEN: $out"
    curl -L -H "Authorization: Bearer $HF_TOKEN" -o "$out" "$url"
  fi
}

mkdir -p $MODELS_DIR/checkpoints $MODELS_DIR/onnx $MODELS_DIR/safetensors

# Example model downloads (YOU MUST REPLACE with actual URLs or model repo files)
# SAM2 model (example placeholder — replace with real direct link)
# hf_download "https://huggingface.co/your-org/sam2/resolve/main/sam2.1_hiera_base_plus.safetensors" "$MODELS_DIR/checkpoints/sam2.1_hiera_base_plus.safetensors"

# wan2.2 animate model placeholder (replace)
# hf_download "https://huggingface.co/your-org/wan2.2/resolve/main/wan2.2_animate_14B_bf16.safetensors" "$MODELS_DIR/checkpoints/wan2.2_animate_14B_bf16.safetensors"

# wan vae
# hf_download "https://huggingface.co/your-org/wan_2.1_vae/resolve/main/wan_2.1_vae.safetensors" "$MODELS_DIR/checkpoints/wan_2.1_vae.safetensors"

# YOLO/vitpose/onnx examples
# hf_download "https://huggingface.co/your-org/yolov10m.onnx/resolve/main/yolov10m.onnx" "$MODELS_DIR/onnx/yolov10m.onnx"
# hf_download "https://huggingface.co/your-org/vitpose_h_wholebody_model.onnx/resolve/main/vitpose_h_wholebody_model.onnx" "$MODELS_DIR/onnx/vitpose_h_wholebody_model.onnx"

# RIFE (example)
# hf_download "https://huggingface.co/your-org/rife49/resolve/main/rife49.pth" "$MODELS_DIR/checkpoints/rife49.pth"

echo "[install-models] done. list:"
ls -lah $MODELS_DIR || true
