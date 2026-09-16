# Day 2 Evidence 06: Health & Connectivity Verification Report

- **Project**: SIMShield
- **Executed At**: 2026-09-12T15:39:30Z
- **Execution Profile**: Resource-Constrained Local Fallback
- **Harness**: `scripts/health-check.ps1`

## 1. Host Port & Health Route Results

| Service | Port | Endpoint Checked | HTTP / Socket Status | Latency (ms) | Verified Role & Boundary |
|---|---|---|---|---|---|
| **Nuxt 3 Web Shell** | `3000` | `http://127.0.0.1:3000/health` | `HTTP 200 OK` | 1396ms | Experience Shell: Fraud Analyst Console |
| **NestJS BFF Gateway** | `3001` | `http://127.0.0.1:3001/health` | `HTTP 200 OK` | 7ms | Orchestration: Self-health verified |
| **FastAPI AI Service** | `8000` | `http://127.0.0.1:8000/health` | `HTTP 200 OK` | 5ms | Intelligence: Truthful standby status |
| **MySQL Relational DB**| `3307` | TCP Connect Handshake | `TCP Active` | 72ms | Relational: Database socket ready |
| **Weaviate Vector DB** | `8080` | `http://127.0.0.1:8080/v1/.well-known/ready` | `HTTP 200 OK` | 1060ms | Vector: Official readiness route verified |

## 2. BFF Aggregated Dependency Contract Output

Query to `GET http://127.0.0.1:3001/health/dependencies`:

```json
{
  "service": "simshield-api",
  "version": "0.1.0",
  "timestamp": "2026-09-12T15:39:30.450Z",
  "status": "healthy",
  "dependencies": {
    "mysql": {
      "status": "healthy",
      "latencyMs": 10,
      "details": {
        "host": "localhost",
        "port": 3307,
        "protocol": "tcp/mysql"
      }
    },
    "weaviate": {
      "status": "healthy",
      "latencyMs": 21,
      "details": {
        "endpoint": "/v1/.well-known/ready",
        "statusCode": 200
      }
    },
    "fastapi": {
      "status": "healthy",
      "latencyMs": 23,
      "details": {
        "service": "simshield-ai",
        "capabilities": {
          "sim_anomaly_detection": "standing_by",
          "risk_scoring_engine": "standing_by",
          "rag_embeddings": "not_configured",
          "llm_reasoning": "not_configured"
        }
      }
    }
  },
  "truthfulStatement": "BFF verified downstream boundaries. Future AI inference capabilities are deferred to Days 8-15."
}
```

## 3. Connectivity Verification Summary
- **Browser-to-BFF**: Verified. Web app on port 3000 queries `http://localhost:3001/health/dependencies` with CORS enabled.
- **BFF-to-MySQL**: Verified on port 3307. Handshake successful.
- **BFF-to-Weaviate**: Verified on port 8080 via `/v1/.well-known/ready`.
- **BFF-to-FastAPI**: Verified on port 8000 via `/health`.
- **Health Truthfulness Gate**: **PASSED**. No future AI or retrieval capabilities claimed as operational.
