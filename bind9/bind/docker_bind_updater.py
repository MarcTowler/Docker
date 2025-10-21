import docker, time, os
from datetime import datetime

ZONE_FILE = "/etc/bind/db.itslit"
BIND_IP = "192.168.1.233"
SERIAL_FMT = "%Y%m%d%H"
client = docker.from_env()

def generate_zone():
    services = client.services.list()
    zone = [
        "$TTL 604800",
        "@   IN  SOA ns1.itslit. admin.itslit. (",
        f"        {datetime.utcnow().strftime(SERIAL_FMT)} ; Serial",
        "        604800 ; Refresh",
        "        86400  ; Retry",
        "        2419200 ; Expire",
        "        604800 ) ; Negative Cache TTL",
        "",
        "@   IN  NS  ns1.itslit.",
        f"ns1 IN  A   {BIND_IP}",
        f"traefik IN  A {BIND_IP}",
        ""
    ]

    for svc in services:
        labels = svc.attrs.get("Spec", {}).get("Labels", {})
        router_rules = [v for k, v in labels.items() if k.startswith("traefik.http.routers.") and ".rule" in k]
        for rule in router_rules:
            hostnames = []
            for part in rule.split("||"):
                if "Host(" in part:
                    for host in part.split("Host(")[1:]:
                        h = host.split(")")[0].strip("` ")
                        if h:
                            hostnames.append(h)
            for hostname in hostnames:
                if ".itslit" in hostname:
                    zone.append(f"{hostname.split('.')[0]} IN A {BIND_IP}")

    with open(ZONE_FILE, "w") as f:
        f.write("\n".join(zone))
    os.system("rndc reload || systemctl reload bind9")
    print(f"[{datetime.now()}] DNS zone updated with {len(services)} services")

def watch_events():
    print("Watching Docker events for service changes...")
    last = ""
    while True:
        try:
            for event in client.events(decode=True):
                if event.get("Type") in ["service"]:
                    generate_zone()
        except Exception as e:
            print("Docker watch error:", e)
            time.sleep(5)

if __name__ == "__main__":
    generate_zone()
    watch_events()
