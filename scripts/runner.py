"""
SIMShield Unified Service Runner
Launches and monitors all five services in a single process tree:
1. MySQL Stub (Port 3307)
2. Weaviate Stub (Port 8080)
3. FastAPI AI Service (Port 8000)
4. NestJS BFF API (Port 3001)
5. Nuxt Web Application (Port 3000)
"""

import subprocess
import sys
import os
import time
import signal

WORKSPACE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
PYTHON_EXE = sys.executable
NODE_EXE = "node"

processes = []

def cleanup(signum=None, frame=None):
    print("\n[Runner] Shutting down all SIMShield services...", flush=True)
    for p in processes:
        if p.poll() is None:
            p.terminate()
    time.sleep(1)
    for p in processes:
        if p.poll() is None:
            p.kill()
    print("[Runner] All services stopped cleanly.", flush=True)
    sys.exit(0)

signal.signal(signal.SIGINT, cleanup)
signal.signal(signal.SIGTERM, cleanup)

def start_services():
    print("=" * 60, flush=True)
    print("   Starting SIMShield 5-Service Topology (Unified Runner)  ", flush=True)
    print("=" * 60, flush=True)

    # 1. MySQL Stub (3307)
    p_mysql = subprocess.Popen(
        [PYTHON_EXE, os.path.join(WORKSPACE, "infrastructure", "stubs", "mysql_stub.py")],
        cwd=os.path.join(WORKSPACE, "infrastructure", "stubs")
    )
    processes.append(p_mysql)
    print("[1/5] MySQL Database Stub started on port 3307", flush=True)

    # 2. Weaviate Stub (8080)
    p_weaviate = subprocess.Popen(
        [PYTHON_EXE, os.path.join(WORKSPACE, "infrastructure", "stubs", "weaviate_stub.py")],
        cwd=os.path.join(WORKSPACE, "infrastructure", "stubs")
    )
    processes.append(p_weaviate)
    print("[2/5] Weaviate Vector DB Stub started on port 8080", flush=True)

    # 3. FastAPI AI Service (8000)
    p_ai = subprocess.Popen(
        [PYTHON_EXE, os.path.join(WORKSPACE, "services", "ai", "main.py")],
        cwd=os.path.join(WORKSPACE, "services", "ai")
    )
    processes.append(p_ai)
    print("[3/5] FastAPI AI Service started on port 8000", flush=True)

    # 4. NestJS BFF API (3001)
    p_bff = subprocess.Popen(
        [NODE_EXE, os.path.join(WORKSPACE, "apps", "api", "dist", "main.js")],
        cwd=os.path.join(WORKSPACE, "apps", "api")
    )
    processes.append(p_bff)
    print("[4/5] NestJS BFF API started on port 3001", flush=True)

    # 5. Nuxt Web UI Shell (3000)
    p_web = subprocess.Popen(
        [NODE_EXE, os.path.join(WORKSPACE, "apps", "web", "server.js")],
        cwd=os.path.join(WORKSPACE, "apps", "web")
    )
    processes.append(p_web)
    print("[5/5] Nuxt Web Application started on port 3000", flush=True)

    print("\nAll 5 services active! Press CTRL+C to terminate.", flush=True)
    print("Web UI:      http://localhost:3000", flush=True)
    print("BFF Health:  http://localhost:3001/health/dependencies", flush=True)
    print("AI Health:   http://localhost:8000/health", flush=True)

    try:
        while True:
            time.sleep(1)
            # Check if any child died unexpectedly
            for p in processes:
                if p.poll() is not None:
                    # Let other processes continue
                    pass
    except KeyboardInterrupt:
        cleanup()

if __name__ == "__main__":
    start_services()
