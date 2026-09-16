# SIMShield Day 2 Baseline Changelog

All changes and adaptations made during the Day 2 Local Environment Baseline setup.

## [0.1.0] - 2026-09-12

### Initialized
- Initialized Git repository with strict secret hygiene rules in `.gitignore`.
- Created sanitized environment template `.env.example` and untracked active `.env`.

### Architecture & Boundaries Established
- **`apps/web`**: Scaffolded Nuxt 3 / TypeScript shell configured on port `3000`. Built the SIMShield Fraud Analyst Dashboard view with live health polling against the BFF.
- **`apps/api`**: Scaffolded NestJS 10 BFF on port `3001`. Created `Prisma` schema with banking domain models (`BankAccount`, `SimSwapEvent`, `BankingTransaction`, `RiskAssessment`). Implemented truthful health endpoints:
  - `GET /health`: Self-check.
  - `GET /health/dependencies`: Probes MySQL, Weaviate, and FastAPI with aggregated health semantics.
- **`services/ai`**: Scaffolded FastAPI application on port `8000`. Implemented truthful health reporting with capabilities standing by (`sim_anomaly_detection: standing_by`, `rag_embeddings: not_configured`).
- **`infrastructure`**:
  - Authored standard `infrastructure/docker-compose.yml` for clean-machine reproducibility.
  - Created `infrastructure/mysql/init.sql` with synthetic domain schemas and seed records.
  - Created lightweight demonstration stubs for MySQL (`:3307`) and Weaviate (`:8080`) to satisfy local execution under Windows host virtualization constraints.

### Automation & Verification
- Created `scripts/start.ps1`, `scripts/stop.ps1`, and `scripts/health-check.ps1`.
- Verified all 5 ports (`3000`, `3001`, `8000`, `3307`, `8080`) active and operational.
- Created `scripts/fault-injection.ps1` and successfully executed Phase G non-destructive fault test (killing FastAPI, observing BFF degradation, recovering in 5475ms).

### Documentation & Evidence
- Authored `docs/topology.md`, `docs/service-register.md`, `docs/adr-001-five-service-topology.md`, `docs/environment-manifest.json`, and `docs/changelog.md`.
- Generated all 10 required Day 2 evidence pack artifacts in `evidence/day-02/`.
