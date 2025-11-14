import subprocess
import sys
import os

print("[runner] Starting ComfyUI...")

args = [
    sys.executable,
    "/workspace/ComfyUI/main.py",
    "--listen", "0.0.0.0",
    "--port", "8188",
    "--disable-auto-launch"
]

if os.environ.get("USE_GPU") == "1":
    print("[runner] GPU mode enabled")
else:
    print("[runner] CPU mode (local testing)")
    args.append("--cpu")

subprocess.run(args)
