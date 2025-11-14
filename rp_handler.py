import runpod
import requests
import time

COMFY = "http://127.0.0.1:8188"

def wait_for_comfy():
    for i in range(60):
        try:
            requests.get(f"{COMFY}/system_stats")
            print("[handler] ComfyUI ready.")
            return True
        except:
            print("[handler] Waiting for ComfyUI...")
            time.sleep(1)
    return False

def handler(job):
    if not wait_for_comfy():
        return {"error": "ComfyUI did not respond"}

    workflow = job["input"].get("workflow")
    if not workflow:
        return {"error": "workflow missing"}

    try:
        res = requests.post(f"{COMFY}/prompt", json=workflow)
        return res.json()
    except Exception as e:
        return {"error": str(e)}

runpod.serverless.start({"handler": handler})
