"""
SIMShield Local Weaviate Stub Service (Port 8080)
Provides official Weaviate readiness routes (/v1/.well-known/ready and /v1/meta)
for local resource-constrained development and BFF dependency verification.
"""

from http.server import HTTPServer, BaseHTTPRequestHandler
import json
import os
import sys

PORT = int(os.getenv("WEAVIATE_PORT", 8080))
HOST = "0.0.0.0"

class WeaviateHandler(BaseHTTPRequestHandler):
    def _send_json(self, status_code, data):
        self.send_response(status_code)
        self.send_header("Content-Type", "application/json")
        self.send_header("Access-Control-Allow-Origin", "*")
        self.end_headers()
        self.wfile.write(json.dumps(data).encode("utf-8"))

    def do_GET(self):
        if self.path in ("/v1/.well-known/ready", "/v1/.well-known/live"):
            self.send_response(200)
            self.send_header("Content-Type", "text/plain")
            self.end_headers()
            self.wfile.write(b"OK")
        elif self.path == "/v1/meta":
            self._send_json(200, {
                "hostname": "simshield-weaviate",
                "version": "1.25.4",
                "modules": {
                    "text2vec-transformers": {
                        "documentationHref": "https://weaviate.io/developers/weaviate/modules/retriever-vectorizer-modules/text2vec-transformers",
                        "status": "ready"
                    }
                }
            })
        elif self.path == "/v1/schema":
            self._send_json(200, {
                "classes": [
                    {
                        "class": "FraudPattern",
                        "description": "Historical SIM-swap and fraud pattern vectors for SIMShield RAG",
                        "vectorizer": "text2vec-transformers",
                        "properties": [
                            {"name": "patternType", "dataType": ["text"]},
                            {"name": "riskIndicator", "dataType": ["text"]},
                            {"name": "syntheticConfidence", "dataType": ["number"]}
                        ]
                    }
                ]
            })
        else:
            self._send_json(200, {
                "service": "simshield-weaviate",
                "status": "operational",
                "message": "SIMShield Weaviate Vector Database Boundary",
                "readiness_route": "/v1/.well-known/ready"
            })

    def log_message(self, format, *args):
        # Concise logging
        sys.stdout.write(f"[Weaviate Stub] {args[0]} {args[1]} -> {args[2]}\n")
        sys.stdout.flush()

def run_server():
    server = HTTPServer((HOST, PORT), WeaviateHandler)
    print(f"[Weaviate Stub] Listening on {HOST}:{PORT} (Readiness: http://localhost:{PORT}/v1/.well-known/ready)", flush=True)
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        pass
    finally:
        server.server_close()

if __name__ == "__main__":
    run_server()
