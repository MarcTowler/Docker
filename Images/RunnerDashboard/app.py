import os, time
from flask import Flask, render_template_string
import requests, jwt

app = Flask(__name__)

def read_secret(path):
    with open(path) as f:
        return f.read().strip()

APP_ID = int(read_secret(os.environ["GITHUB_APP_ID_FILE"]))
with open(os.environ["GITHUB_APP_PK_FILE"]) as f:
    APP_PK = f.read()

INST_ORG = int(read_secret(os.environ["GITHUB_INSTALLATION_ID_ORG_FILE"]))
INST_PERSONAL = int(read_secret(os.environ["GITHUB_INSTALLATION_ID_PERSONAL_FILE"]))

ORG = "ItsLit-Media-and-Development"
PERSONAL_OWNER = "your-github-user"
PERSONAL_REPO = "your-personal-repo"

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

def list_runners_org():
    token = get_install_token(INST_ORG)
    r = requests.get(
        f"https://api.github.com/orgs/{ORG}/actions/runners",
        headers={"Authorization": f"Bearer {token}",
                 "Accept": "application/vnd.github+json"},
        timeout=10,
    )
    r.raise_for_status()
    return r.json()["runners"]

def list_runners_personal():
    token = get_install_token(INST_PERSONAL)
    r = requests.get(
        f"https://api.github.com/repos/{PERSONAL_OWNER}/{PERSONAL_REPO}/actions/runners",
        headers={"Authorization": f"Bearer {token}",
                 "Accept": "application/vnd.github+json"},
        timeout=10,
    )
    r.raise_for_status()
    return r.json()["runners"]

TEMPLATE = """
<!doctype html>
<html>
<head>
  <title>ItsLit GitHub Runners</title>
  <style>
    body { font-family: sans-serif; margin: 2rem; background: #111; color: #eee; }
    h1 { margin-bottom: 0.5rem; }
    table { border-collapse: collapse; width: 100%; margin-bottom: 2rem; }
    th, td { border: 1px solid #444; padding: 0.4rem 0.6rem; }
    th { background: #222; }
    .online { color: #4caf50; }
    .offline { color: #f44336; }
    .busy { font-weight: bold; }
  </style>
</head>
<body>
  <h1>ItsLit GitHub Runners</h1>
  <h2>Organisation: {{ org }}</h2>
  <table>
    <tr><th>Name</th><th>Status</th><th>Busy</th><th>Labels</th></tr>
    {% for r in org_runners %}
      <tr>
        <td>{{ r.name }}</td>
        <td class="{{ r.status|lower }}">{{ r.status }}</td>
        <td class="{{ 'busy' if r.busy else '' }}">{{ 'Yes' if r.busy else 'No' }}</td>
        <td>{{ r.labels|join(', ') }}</td>
      </tr>
    {% endfor %}
  </table>

  <h2>Personal: {{ personal }}</h2>
  <table>
    <tr><th>Name</th><th>Status</th><th>Busy</th><th>Labels</th></tr>
    {% for r in personal_runners %}
      <tr>
        <td>{{ r.name }}</td>
        <td class="{{ r.status|lower }}">{{ r.status }}</td>
        <td class="{{ 'busy' if r.busy else '' }}">{{ 'Yes' if r.busy else 'No' }}</td>
        <td>{{ r.labels|join(', ') }}</td>
      </tr>
    {% endfor %}
  </table>
</body>
</html>
"""

@app.route("/")
def index():
    org_runners_raw = list_runners_org()
    personal_runners_raw = list_runners_personal()

    def map_runner(r):
        return {
            "name": r["name"],
            "status": r["status"],
            "busy": r["busy"],
            "labels": [l["name"] for l in r["labels"]],
        }

    org_runners = [map_runner(r) for r in org_runners_raw]
    personal_runners = [map_runner(r) for r in personal_runners_raw]

    return render_template_string(
        TEMPLATE,
        org=ORG,
        personal=f"{PERSONAL_OWNER}/{PERSONAL_REPO}",
        org_runners=org_runners,
        personal_runners=personal_runners,
    )

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
