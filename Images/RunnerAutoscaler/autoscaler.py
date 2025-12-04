import os
import time
import threading
import traceback
import json

from flask import Flask, request
import requests
import jwt
import docker

app = Flask(__name__)
client = docker.from_env()

API_URL = "https://api.github.com"

# ---------------------------
# Env + secrets helpers
# ---------------------------

def getenv(name, default=None, required=False):
    v = os.environ.get(name, default)
    if required and not v:
        raise RuntimeError(f"Missing required env var: {name}")
    return v

def read_file(path):
    with open(path, "r") as f:
        return f.read().strip()

STACK_NAME = getenv("SWARM_STACK_NAME", "github-runners")

ORG_OWNER = getenv("ORG_OWNER", "ItsLit-Media-and-Development")
PERSONAL_OWNER = getenv("PERSONAL_OWNER", "MarcTowler")
PERSONAL_REPO = getenv("PERSONAL_REPO", "Docker")

ORG_MIN = int(getenv("ORG_MIN_RUNNERS", "1"))
ORG_MAX = int(getenv("ORG_MAX_RUNNERS", "5"))
PER_MIN = int(getenv("PERSONAL_MIN_RUNNERS", "0"))
PER_MAX = int(getenv("PERSONAL_MAX_RUNNERS", "3"))

SCAN_INTERVAL = int(getenv("SCAN_INTERVAL_SECONDS", "20"))
IDLE_SECONDS_BEFORE_SCALE_DOWN = int(getenv("IDLE_SECONDS_BEFORE_SCALE_DOWN", "300"))

AUTO_UPDATE_ORG = getenv("AUTO_UPDATE_ORG", "true").lower() == "true"
AUTO_UPDATE_PERSONAL = getenv("AUTO_UPDATE_PERSONAL", "true").lower() == "true"

GITHUB_APP_ID_FILE = getenv("GITHUB_APP_ID_FILE", required=True)
GITHUB_APP_PK_FILE = getenv("GITHUB_APP_PK_FILE", required=True)
GITHUB_INSTALLATION_ID_ORG_FILE = getenv("GITHUB_INSTALLATION_ID_ORG_FILE", required=True)
GITHUB_INSTALLATION_ID_PERSONAL_FILE = getenv("GITHUB_INSTALLATION_ID_PERSONAL_FILE", required=True)

DISCORD_WEBHOOK_FILE = getenv("DISCORD_WEBHOOK_FILE", "")
DISCORD_WEBHOOK_URL = getenv("DISCORD_WEBHOOK_URL", "")

APP_ID = int(read_file(GITHUB_APP_ID_FILE))
with open(GITHUB_APP_PK_FILE, "r") as f:
    APP_PK = f.read()

INST_ORG = int(read_file(GITHUB_INSTALLATION_ID_ORG_FILE))
INST_PER = int(read_file(GITHUB_INSTALLATION_ID_PERSONAL_FILE))

if DISCORD_WEBHOOK_FILE and not DISCORD_WEBHOOK_URL:
    try:
        DISCORD_WEBHOOK_URL = read_file(DISCORD_WEBHOOK_FILE)
    except FileNotFoundError:
        DISCORD_WEBHOOK_URL = ""

# ---------------------------
# Discord
# ---------------------------

def send_discord(title, description, level="info"):
    if not DISCORD_WEBHOOK_URL:
        print(f"[discord-{level}] {title}: {description}")
        return

    color_map = {
        "info": 0x3498db,
        "success": 0x2ecc71,
        "warn": 0xf1c40f,
        "error": 0xe74c3c,
    }
    color = color_map.get(level, 0x3498db)

    payload = {
        "embeds": [
            {
                "title": title,
                "description": description,
                "color": color,
            }
        ]
    }

    try:
        r = requests.post(DISCORD_WEBHOOK_URL, json=payload, timeout=10)
        if r.status_code >= 300:
            print(f"[discord] Failed to send ({r.status_code}): {r.text}")
    except Exception as e:
        print(f"[discord] Exception sending message: {e}")

# ---------------------------
# GitHub App helpers
# ---------------------------

def make_jwt():
    now = int(time.time())
    payload = {
        "iat": now - 60,
        "exp": now + 9 * 60,
        "iss": APP_ID,
    }
    return jwt.encode(payload, APP_PK, algorithm="RS256")

def get_install_token(installation_id):
    jwt_token = make_jwt()
    r = requests.post(
        f"{API_URL}/app/installations/{installation_id}/access_tokens",
        headers={
            "Authorization": f"Bearer {jwt_token}",
            "Accept": "application/vnd.github+json",
        },
        timeout=15,
    )
    r.raise_for_status()
    return r.json()["token"]

def github_get(url, installation_id, auth=True):
    headers = {"Accept": "application/vnd.github+json"}
    if auth:
        token = get_install_token(installation_id)
        headers["Authorization"] = f"Bearer {token}"

    r = requests.get(url, headers=headers, timeout=15)
    r.raise_for_status()
    return r.json()

# ---------------------------
# Global state
# ---------------------------

pending_org = 0
pending_personal = 0

last_activity_org = time.time()
last_activity_personal = time.time()

last_runners_org = {}
last_runners_personal = {}

latest_runner_version = None
latest_version_checked_at = 0

error_count = 0
lock = threading.Lock()

# ---------------------------
# Docker helpers
# ---------------------------

def scale_service(service_suffix, replicas):
    svc_name = f"{STACK_NAME}_{service_suffix}"
    svc = client.services.get(svc_name)
    current = svc.attrs["Spec"]["Mode"]["Replicated"]["Replicas"]
    if current != replicas:
        svc.scale(replicas)
        msg = f"Service `{svc_name}` scaled from {current} → {replicas}"
        print("[scale]", msg)
        send_discord("Runner scaling", msg, level="info")

def restart_service(service_suffix):
    svc_name = f"{STACK_NAME}_{service_suffix}"
    svc = client.services.get(svc_name)
    spec = svc.attrs["Spec"]
    mode = spec["Mode"]
    if "Replicated" not in mode:
        return
    replicas = mode["Replicated"]["Replicas"]
    if replicas == 0:
        # nothing running; scaling up will start fresh with new image
        send_discord("Runner auto-update",
                     f"Service `{svc_name}` has 0 replicas; skipping restart (will update when scaled up).",
                     level="info")
        return
    send_discord(
        "Runner auto-update",
        f"Restarting service `{svc_name}` for runner auto-update (replicas={replicas})",
        level="warn",
    )
    svc.scale(0)
    time.sleep(5)
    svc.scale(replicas)

# ---------------------------
# Runner monitoring
# ---------------------------

def fetch_runners_org():
    data = github_get(f"{API_URL}/orgs/{ORG_OWNER}/actions/runners", INST_ORG)
    return data.get("runners", [])

def fetch_runners_personal():
    full = f"{PERSONAL_OWNER}/{PERSONAL_REPO}"
    data = github_get(f"{API_URL}/repos/{full}/actions/runners", INST_PER)
    return data.get("runners", [])

def reduce_runners(runners):
    res = {}
    for r in runners:
        res[r["id"]] = {
            "name": r["name"],
            "status": r["status"],
            "busy": r["busy"],
            "version": r.get("version"),
        }
    return res

def diff_runners(old, new, scope_label):
    for rid, info in new.items():
        if rid not in old:
            send_discord(
                "Runner online",
                f"[{scope_label}] `{info['name']}` is now registered ({info['status']}, busy={info['busy']}, v={info.get('version')})",
                level="success",
            )
        else:
            prev = old[rid]
            if prev["status"] != info["status"]:
                send_discord(
                    "Runner status change",
                    f"[{scope_label}] `{info['name']}`: {prev['status']} → {info['status']}",
                    level="info",
                )
            if prev["busy"] != info["busy"]:
                send_discord(
                    "Runner busy change",
                    f"[{scope_label}] `{info['name']}` busy={prev['busy']} → {info['busy']}",
                    level="info",
                )

    for rid, info in old.items():
        if rid not in new:
            send_discord(
                "Runner removed",
                f"[{scope_label}] `{info['name']}` is no longer registered",
                level="warn",
            )

# ---------------------------
# Latest runner version
# ---------------------------

def parse_version(v):
    try:
        parts = v.split(".")
        return tuple(int(p) for p in parts)
    except Exception:
        return (0, 0, 0)

def check_latest_runner_version():
    global latest_runner_version, latest_version_checked_at
    now = int(time.time())
    if latest_runner_version and now - latest_version_checked_at < 3600:
        return latest_runner_version

    data = github_get(
        "https://api.github.com/repos/actions/runner/releases/latest",
        installation_id=INST_ORG,
        auth=False,  # public endpoint; no auth needed
    )
    tag = data.get("tag_name", "")  # e.g. v2.319.1
    if tag.startswith("v"):
        tag = tag[1:]
    latest_runner_version = tag
    latest_version_checked_at = now
    print(f"[version] Latest GitHub runner version: {latest_runner_version}")
    return latest_runner_version

def find_outdated(runners, scope_label):
    latest = check_latest_runner_version()
    if not latest:
        return []
    latest_t = parse_version(latest)
    outdated = []
    for r in runners.values():
        v = r.get("version")
        if not v:
            continue
        if parse_version(v) < latest_t:
            outdated.append((r["name"], v))
    if outdated:
        msg_lines = [f"{name} (v{v})" for name, v in outdated]
        msg = f"[{scope_label}] Outdated runners detected vs latest v{latest}:\n" + "\n".join(msg_lines)
        send_discord("Runner version out-of-date", msg, level="warn")
    return outdated

# ---------------------------
# Reconcile loop
# ---------------------------

def compute_target(pending, busy, minimum, maximum, last_activity, now):
    if pending == 0 and busy == 0 and (now - last_activity) > IDLE_SECONDS_BEFORE_SCALE_DOWN:
        return minimum
    desired = max(pending + busy, minimum)
    desired = min(desired, maximum)
    return desired

def reconcile():
    global pending_org, pending_personal
    global last_activity_org, last_activity_personal
    global last_runners_org, last_runners_personal
    global error_count

    while True:
        time.sleep(SCAN_INTERVAL)
        try:
            with lock:
                po = pending_org
                pp = pending_personal

            org_runners_raw = fetch_runners_org()
            per_runners_raw = fetch_runners_personal()

            org_map = reduce_runners(org_runners_raw)
            per_map = reduce_runners(per_runners_raw)

            diff_runners(last_runners_org, org_map, "org")
            diff_runners(last_runners_personal, per_map, "personal")

            last_runners_org = org_map
            last_runners_personal = per_map

            busy_org = sum(1 for r in org_map.values() if r["busy"])
            busy_per = sum(1 for r in per_map.values() if r["busy"])

            now = time.time()

            if po > 0 or busy_org > 0:
                last_activity_org = now
            if pp > 0 or busy_per > 0:
                last_activity_personal = now

            org_target = compute_target(po, busy_org, ORG_MIN, ORG_MAX, last_activity_org, now)
            per_target = compute_target(pp, busy_per, PER_MIN, PER_MAX, last_activity_personal, now)

            scale_service("runner_org", org_target)
            scale_service("runner_personal", per_target)

            # Auto-update behaviour
            outdated_org = find_outdated(org_map, "org")
            if AUTO_UPDATE_ORG and outdated_org:
                restart_service("runner_org")

            outdated_per = find_outdated(per_map, "personal")
            if AUTO_UPDATE_PERSONAL and outdated_per:
                restart_service("runner_personal")

            error_count = 0
        except Exception as e:
            error_count += 1
            print("[reconcile] error:", e)
            traceback.print_exc()
            if error_count == 1 or error_count % 5 == 0:
                send_discord(
                    "Autoscaler error",
                    f"Error in reconcile loop (count={error_count}):\n```{traceback.format_exc()}```",
                    level="error",
                )

# ---------------------------
# Webhooks
# ---------------------------

@app.route("/", methods=["POST"])
def webhook():
    global pending_org, pending_personal, last_activity_org, last_activity_personal

    event = request.headers.get("X-GitHub-Event", "")
    if event != "workflow_job":
        return "", 204

    payload = request.json or {}
    job = payload.get("workflow_job") or {}
    action = payload.get("action")
    labels = set(job.get("labels") or [])
    repo_full = payload.get("repository", {}).get("full_name", "")

    if "self-hosted" not in labels or "swarm" not in labels:
        return "", 202

    is_org = repo_full.startswith(f"{ORG_OWNER}/")
    is_personal = repo_full == f"{PERSONAL_OWNER}/{PERSONAL_REPO}"

    if not (is_org or is_personal):
        return "", 202

    now = time.time()
    with lock:
        if action == "queued":
            if is_org:
                pending_org += 1
                last_activity_org = now
            elif is_personal:
                pending_personal += 1
                last_activity_personal = now
        elif action == "completed":
            if is_org:
                pending_org = max(0, pending_org - 1)
                last_activity_org = now
            elif is_personal:
                pending_personal = max(0, pending_personal - 1)
                last_activity_personal = now

    return "", 202

@app.route("/health", methods=["GET"])
def health():
    with lock:
        data = {
            "pending_org": pending_org,
            "pending_personal": pending_personal,
            "org_min": ORG_MIN,
            "org_max": ORG_MAX,
            "personal_min": PER_MIN,
            "personal_max": PER_MAX,
        }
    return json.dumps(data), 200, {"Content-Type": "application/json"}

# ---------------------------
# Main
# ---------------------------

if __name__ == "__main__":
    send_discord("Autoscaler starting", "Autoscaler service has started up", level="info")
    threading.Thread(target=reconcile, daemon=True).start()
    app.run(host="0.0.0.0", port=8080)
