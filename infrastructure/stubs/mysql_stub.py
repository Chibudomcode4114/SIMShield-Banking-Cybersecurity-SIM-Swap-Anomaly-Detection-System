"""
SIMShield Local MySQL Stub Service (Port 3307)
Provides a lightweight TCP handshake listener for local resource-constrained development,
allowing BFF dependency health checks to verify relational database reachability.
"""

import socket
import os
import sys
import threading

PORT = int(os.getenv("MYSQL_PORT", 3307))
HOST = "0.0.0.0"

def build_mysql_handshake():
    # Minimal valid MySQL Initial Handshake Packet (Protocol version 10)
    server_version = b"8.0.36-simshield-local\x00"
    thread_id = (1).to_bytes(4, byteorder="little")
    salt1 = b"12345678"
    caps1 = (0xf7ff).to_bytes(2, byteorder="little")
    charset = b"\x21" # utf8_general_ci
    status = (0x0002).to_bytes(2, byteorder="little") # SERVER_STATUS_AUTOCOMMIT
    caps2 = (0x81ff).to_bytes(2, byteorder="little")
    auth_plugin_len = b"\x15"
    reserved = b"\x00" * 10
    salt2 = b"123456789012\x00"
    plugin_name = b"caching_sha2_password\x00"

    payload = (
        b"\x0a" + server_version + thread_id + salt1 +
        b"\x00" + caps1 + charset + status + caps2 +
        auth_plugin_len + reserved + salt2 + plugin_name
    )
    packet_len = len(payload).to_bytes(3, byteorder="little")
    seq = b"\x00"
    return packet_len + seq + payload

def handle_client(conn, addr):
    try:
        conn.settimeout(5.0)
        handshake = build_mysql_handshake()
        conn.sendall(handshake)
        # Receive client response or probe
        conn.recv(1024)
    except Exception:
        pass
    finally:
        conn.close()

def run_server():
    server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    try:
        server.bind((HOST, PORT))
        server.listen(10)
        print(f"[MySQL Stub] Listening on {HOST}:{PORT} (SIMShield Database Fallback)", flush=True)
        while True:
            conn, addr = server.accept()
            t = threading.Thread(target=handle_client, args=(conn, addr), daemon=True)
            t.start()
    except Exception as e:
        print(f"[MySQL Stub] Error: {e}", file=sys.stderr, flush=True)
    finally:
        server.close()

if __name__ == "__main__":
    run_server()
