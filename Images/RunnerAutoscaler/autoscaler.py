import os, time, threading
from flask import Flask, request
import docker, jwt, requests

app = Flask(__name__)
client = docker.from_env()

# Read secrets from files in /run/secrets
def read_secret(path):
    with open(path, "r") as f:
        return f.read().strip()

APP_ID = int(read_secret(os.environ["GITHUB_APP_ID_FILE"]))
with open(os.environ["GITHUB_APP_PK_FILE"]) as f:
    APP_PK = f.read()

INST_ORG = int(read_secret(os.environ["GITHUB_INSTALLATION_ID_ORG_FILE"]))
INST_PERSONAL = int(read_secret(os.environ["GITHUB_INSTALLATION_ID_PERSONAL_FILE"]))

STACK = os.environ.get("SWARM_STACK_NAME", "github-runners")

ORG_MIN = int(os.environ.get("ORG_MIN_RUNNERS", "1"))
ORG_MAX = int(os.environ.get("ORG_MAX_RUNNERS", "5"))
PER_MIN = int(os.environ.get("PERSONAL_MIN_RUNNERS", "0"))
PER_MAX = int(os.environ.get("PERSONAL_MAX_RUNNERS", "3"))

def make_jwt():
    now = int(time.time())
    payload = {"iat": now - 60, "exp": now + 9*60, "iss": APP_ID}
    return jwt.encode(payload, APP_PK, algorithm="RS256")

def get_install_token(installation_id):
    jwt_token = make_jwt()
    r = requests.post(
        f"https://api.github.com/app/installations/{installation_id}/access_tokens",
        headers={
            "Authorization": f"Bearer {jwt_token}",
            "Accept": "application/vnd.github+json",
        },
        timeout=10,
    )
    r.raise_for_status()
    return r.json()["token"]

# naive in-memory tracking
pending_org_jobs = 0
pending_personal_jobs = 0

def scale_service(name, replicas):
    svc_name = f"{STACK}_{name}"
    svc = client.services.get(svc_name)
    current = svc.attrs["Spec"]["Mode"]["Replicated"]["Replicas"]
    if current != replicas:
        svc.scale(replicas)

def reconcile():
    while True:
        try:
            org_target = min(max(ORG_MIN, pending_org_jobs), ORG_MAX)
            per_target = min(max(PER_MIN, pending_personal_jobs), PER_MAX)
            scale_service("runner_org", org_target)
            scale_service("runner_personal", per_target)
        except Exception as e:
            print("reconcile error:", e, flush=True)
        time.sleep(15)

@app.route("/", methods=["POST"])
def webhook():
    event = request.headers.get("X-GitHub-Event")
    if event != "workflow_job":
        return "", 204

    payload = request.json
    labels = set(payload["workflow_job"]["labels"])
    repo_full_name = payload["repository"]["full_name"]
    action = payload["action"]  # queued / in_progress / completed

    global pending_org_jobs, pending_personal_jobs

    if "self-hosted" in labels and "swarm" in labels:
        if repo_full_name.startswith("ItsLit-Media-and-Development/"):
            if action == "queued":
                pending_org_jobs += 1
            elif action == "completed":
                pending_org_jobs = max(ORG_MIN, pending_org_jobs - 1)
        else:
            if action == "queued":
                pending_personal_jobs += 1
            elif action == "completed":
                pending_personal_jobs = max(PER_MIN, pending_personal_jobs - 1)

    return "", 202

if __name__ == "__main__":
    threading.Thread(target=reconcile, daemon=True).start()
    app.run(host="0.0.0.0", port=8080)