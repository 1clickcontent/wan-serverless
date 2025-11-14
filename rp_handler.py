import runpod
import requests
import time

COMFY_URL = "http://127.0.0.1:8188"

def wait_for_comfy():
    for i in range(60):
        try:
            r = requests.get(f"{COMFY_URL}/system_stats")
            print("[handler] ComfyUI is ready.")
            return True
        except:
            print("[handler] Waiting for ComfyUI startup...")
            time.sleep(1)
    return False


def handler(job):

    if not wait_for_comfy():
        return {"error": "ComfyUI did not respond"}

    workflow = job["input"].get("workflow")

    if workflow is None:
        return {"error": "Missing workflow in request payload"}

    try:
        res = requests.post(f"{COMFY_URL}/prompt", json=workflow)
        return res.json()
    except Exception as e:
        return {"error": str(e)}


runpod.serverless.start({"handler": handler})
