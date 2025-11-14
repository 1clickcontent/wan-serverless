#!/usr/bin/env bash
set -e
WORKDIR=/workspace/models
mkdir -p ${WORKDIR}/checkpoints ${WORKDIR}/sam2 ${WORKDIR}/rife ${WORKDIR}/wan ${WORKDIR}/dwpose

echo "[models] Ensure models dir present: ${WORKDIR}"

# NOTE: For Opsi A (include models in image), prefer copying local models/ into build context.
# Below are example curl/wget commands if you want the container to download models during build.
# You must replace placeholder URLs with valid direct links (S3, HuggingFace, or your bucket).

# Example: download sam2 (placeholder - replace with real URL)
# if [ ! -f "${WORKDIR}/sam2/sam2_hiera_large.pt" ]; then
#   echo "[models] Downloading SAM2 large..."
#   curl -L -o ${WORKDIR}/sam2/sam2_hiera_large.pt "https://your-storage/sam2_hiera_large.pt"
# fi

# Example: copy wan/checkpoints if you included them in build context (already copied by Dockerfile COPY models ...)
echo "[models] done (no-op). If you want automatic downloads, edit this script and add real URLs."
