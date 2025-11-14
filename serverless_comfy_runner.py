import subprocess
import sys
import os

print("[runner] Starting ComfyUI server...")

args = [
    sys.executable,
    "/workspace/ComfyUI/main.py",
    "--listen", "0.0.0.0",
    "--port", "8188",
    "--disable-auto-launch"
]

# Local CPU mode (USE_GPU not set)
if os.environ.get("USE_GPU") != "1":
    print("[runner] Using CPU mode for local testing")
    args.append("--cpu")
else:
    print("[runner] Using GPU mode for RunPod")

subprocess.run(args)
