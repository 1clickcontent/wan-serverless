import runpod
import requests
import time

COMFY_URL = "http://127.0.0.1:8188"

# Wait for ComfyUI server to fully boot
def wait_for_comfy():
    for i in range(60):
        try:
            requests.get(f"{COMFY_URL}/system_stats")
            print("ComfyUI is ready.")
            return True
        except:
            print("Waiting for ComfyUI...")
            time.sleep(1)
    return False


def handler(job):
    # Ensure comfy is ready
    if not wait_for_comfy():
        return {"error": "ComfyUI not ready"}

    workflow = job["input"].get("workflow")

    if workflow is None:
        return {"error": "Missing workflow JSON"}

    # Forward workflow to ComfyUI
    try:
        res = requests.post(f"{COMFY_URL}/prompt", json=workflow)
        result = res.json()
        return {"result": result}
    except Exception as e:
        return {"error": str(e)}


runpod.serverless.start({"handler": handler})
