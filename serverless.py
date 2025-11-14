import subprocess
import sys
import os

print("Starting ComfyUI in serverless mode...")

args = [
    sys.executable,
    "/workspace/ComfyUI/main.py",
    "--listen", "0.0.0.0",
    "--port", "8188",
    "--disable-auto-launch"
]

# LOCAL MODE → CPU only (karena local kamu tidak ada GPU)
if os.environ.get("USE_GPU") != "1":
    print("Running in CPU mode (local test)")
    args.append("--cpu")
else:
    print("Running in GPU mode (RunPod)")

subprocess.run(args, check=True)
