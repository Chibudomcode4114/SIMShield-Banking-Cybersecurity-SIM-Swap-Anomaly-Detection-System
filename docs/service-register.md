# SIMShield Service Ownership & Port Register

This register details all five services, network ports, runtimes, boundary owners, and current vs. future domain responsibilities.

| Service Name | Boundary Owner | Runtime / Toolchain | Host Port | Internal Port | Protocol | Health Route | Current Day 2 State | Future Domain Milestone |
|---|---|---|---|---|---|---|---|---|
| **simshield-web** | Frontend Engineer | Nuxt 3, Vue 3, TypeScript, Node.js 22 | `3000` | `3000` | HTTP | `GET /health` | Operational (UI Shell & Status Monitor) | Day 3: Multi-actor Analyst & Admin Consoles |
| **simshield-api** | Backend Architect | NestJS 10, Express, TypeScript, Node.js 22 | `3001` | `3001` | HTTP | `GET /health`, `GET /health/dependencies` | Operational (Gateway & Dependency Probing) | Day 4: Transaction & Event State Machine |
| **simshield-ai** | AI Engineer | FastAPI 0.115, Uvicorn, Python 3.13 | `8000` | `8000` | HTTP | `GET /health` | Operational (Truthful Standby Status) | Days 8-11: Rule & Anomaly Scoring Engine |
| **simshield-mysql** | Database Administrator | MySQL 8.0 / Prisma ORM | `3307` | `3306` | TCP/MySQL | TCP Ping / `mysqladmin ping` | Active Handshake / Initial Schemas Ready | Days 4-7: Relational Customer & Transaction Logs |
| **simshield-weaviate**| AI/Data Engineer | Weaviate 1.25.4 (Vector DB) | `8080` | `8080` | HTTP | `GET /v1/.well-known/ready` | Active Readiness Endpoint (`/v1/meta`) | Days 12-15: Fraud Pattern Vector Retrieval |

## Deferred Components (Explicit Non-Goals for Day 2)
The following components are intentionally deferred and not scaffolded in Day 2:
- **Redis**: Caching session tokens and rate limiting (deferred to Day 16).
- **Neo4j**: Graph analysis of syndicates (deferred beyond 19-day MVP scope).
- **Keycloak**: External IAM (BFF owns basic auth contracts in MVP).
- **Live LLM Models / Weights**: Foundation models and GPU inference (deferred to Day 8).
