# Day 2 Evidence 07: Controlled Fault Injection and Recovery Report

- **Project**: SIMShield (Banking Cybersecurity / SIM-Swap Anomaly Detection)
- **Environment Profile**: Resource-Constrained Local Fallback
- **Target Fault**: Non-destructive termination of FastAPI AI Service (Host Port 8000)
- **Induced By**: Automated test harness (\scripts/fault-injection.ps1\)

## Timeline of Fault Injection

| Event | Timestamp (UTC) | Observed Status | Component Behavior |
|---|---|---|---|
| 1. Baseline Capture | 2026-09-16T22:39:59Z | Healthy | All 5 services operational; BFF aggregated status = healthy |
| 2. Fault Injection | 2026-09-16T22:39:59Z | Offline (:8000) | Process PID 16148 killed; port 8000 closed |
| 3. Degraded Detection | 2026-09-16T22:40:04Z | Degraded | BFF reports status = degraded; Web UI presents warning banner |
| 4. Service Restart | 2026-09-16T22:40:10Z | Restarted | FastAPI restarted via background process |
| 5. Post-Recovery | 2026-09-16T22:40:10Z | Healthy | BFF reports status = healthy in 5475ms |

## Detailed State Payloads

### 1. Healthy Baseline Payload
\\\json
{
    "service":  "simshield-api",
    "version":  "0.1.0",
    "timestamp":  "2026-09-16T22:39:59.570Z",
    "status":  "healthy",
    "dependencies":  {
                         "mysql":  {
                                       "status":  "healthy",
                                       "latencyMs":  15,
                                       "details":  {
                                                       "host":  "localhost",
                                                       "port":  3307,
                                                       "protocol":  "tcp/mysql"
                                                   }
                                   },
                         "weaviate":  {
                                          "status":  "healthy",
                                          "latencyMs":  24,
                                          "details":  {
                                                          "endpoint":  "/v1/.well-known/ready",
                                                          "statusCode":  200
                                                      }
                                      },
                         "fastapi":  {
                                         "status":  "healthy",
                                         "latencyMs":  32,
                                         "details":  {
                                                         "service":  "simshield-ai",
                                                         "capabilities":  {
                                                                              "sim_anomaly_detection":  "standing_by",
                                                                              "risk_scoring_engine":  "standing_by",
                                                                              "rag_embeddings":  "not_configured",
                                                                              "llm_reasoning":  "not_configured"
                                                                          }
                                                     }
                                     }
                     },
    "truthfulStatement":  "BFF verified downstream boundaries. Future AI inference capabilities are deferred to Days 8-15."
}
\\\

### 2. Degraded State Payload (FastAPI Offline)
\\\json
{
    "service":  "simshield-api",
    "version":  "0.1.0",
    "timestamp":  "2026-09-16T22:40:04.646Z",
    "status":  "degraded",
    "dependencies":  {
                         "mysql":  {
                                       "status":  "healthy",
                                       "latencyMs":  36,
                                       "details":  {
                                                       "host":  "localhost",
                                                       "port":  3307,
                                                       "protocol":  "tcp/mysql"
                                                   }
                                   },
                         "weaviate":  {
                                          "status":  "healthy",
                                          "latencyMs":  65,
                                          "details":  {
                                                          "endpoint":  "/v1/.well-known/ready",
                                                          "statusCode":  200
                                                      }
                                      },
                         "fastapi":  {
                                         "status":  "unavailable",
                                         "error":  "fetch failed"
                                     }
                     },
    "truthfulStatement":  "BFF verified downstream boundaries. Future AI inference capabilities are deferred to Days 8-15."
}
\\\

### 3. Post-Recovery Payload
\\\json
{
    "service":  "simshield-api",
    "version":  "0.1.0",
    "timestamp":  "2026-09-16T22:40:11.377Z",
    "status":  "healthy",
    "dependencies":  {
                         "mysql":  {
                                       "status":  "healthy",
                                       "latencyMs":  15,
                                       "details":  {
                                                       "host":  "localhost",
                                                       "port":  3307,
                                                       "protocol":  "tcp/mysql"
                                                   }
                                   },
                         "weaviate":  {
                                          "status":  "healthy",
                                          "latencyMs":  18,
                                          "details":  {
                                                          "endpoint":  "/v1/.well-known/ready",
                                                          "statusCode":  200
                                                      }
                                      },
                         "fastapi":  {
                                         "status":  "healthy",
                                         "latencyMs":  208,
                                         "details":  {
                                                         "service":  "simshield-ai",
                                                         "capabilities":  {
                                                                              "sim_anomaly_detection":  "standing_by",
                                                                              "risk_scoring_engine":  "standing_by",
                                                                              "rag_embeddings":  "not_configured",
                                                                              "llm_reasoning":  "not_configured"
                                                                          }
                                                     }
                                     }
                     },
    "truthfulStatement":  "BFF verified downstream boundaries. Future AI inference capabilities are deferred to Days 8-15."
}
\\\

## Acceptance Conclusion
- **Visible Degraded Behavior**: BFF cleanly caught the connection error to port 8000 without crashing, returning an aggregated \degraded\ status and preserving core database connectivity. Nuxt Web UI rendered the corresponding warning banner.
- **Recovery Duration**: 5475 ms.
- **Result**: PASS (Controlled dependency fault detected and safely recovered without repository rebuild).
