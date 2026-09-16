# Day 2 Evidence 03: Service & Port Register

- **Project Slug**: `simshield`
- **Environment**: Development / Local Baseline

| Service | Runtime | Host Port | Internal Port | Boundary Owner | Health Endpoint | Verified Status |
|---|---|---|---|---|---|---|
| **simshield-web** | Nuxt 3 / Node 22 | `3000` | `3000` | Experience Team | `GET /health` | **HEALTHY** (HTTP 200) |
| **simshield-api** | NestJS / Node 22 | `3001` | `3001` | Orchestration Team | `GET /health`, `GET /health/dependencies` | **HEALTHY** (HTTP 200) |
| **simshield-ai** | FastAPI / Python 3.13 | `8000` | `8000` | Intelligence Team | `GET /health` | **HEALTHY** (HTTP 200) |
| **simshield-mysql** | MySQL 8.0 / Prisma | `3307` | `3306` | Data Team | TCP Port 3307 Handshake | **HEALTHY** (TCP Active) |
| **simshield-weaviate**| Weaviate 1.25.4 | `8080` | `8080` | Data Team | `GET /v1/.well-known/ready` | **HEALTHY** (HTTP 200) |

## Port Register Integrity
- No two services share a port.
- MySQL is bound to port `3307` to prevent collision with local pre-existing MySQL installations.
- Vector search is bound to `8080`.
