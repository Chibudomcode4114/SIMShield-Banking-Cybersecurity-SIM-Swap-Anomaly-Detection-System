# SIMShield End-to-End Service Topology & Trust Boundaries

## Overview
SIMShield implements a strict five-service local architecture ensuring complete separation among **Experience**, **Orchestration**, **Intelligence**, and **Data Storage** boundaries.

```mermaid
flowchart TD
    subgraph ClientZone ["Browser & Client Boundary (Host Access)"]
        User["Bank Fraud / Security Analyst"]
    end

    subgraph ExperienceZone ["Experience Boundary (:3000)"]
        Web["Nuxt 3 Web Shell<br/>apps/web<br/>Vue 3 + TypeScript"]
    end

    subgraph OrchestrationZone ["Orchestration Boundary (:3001)"]
        BFF["NestJS BFF & Gateway<br/>apps/api<br/>Node.js 22 + Prisma"]
    end

    subgraph IntelligenceZone ["Intelligence Boundary (:8000)"]
        AI["FastAPI AI Service<br/>services/ai<br/>Python 3.13 + Uvicorn"]
    end

    subgraph DataZone ["Data Boundaries (:3307 & :8080)"]
        MySQL[("MySQL 8.0<br/>Port 3307<br/>Transactional Store")]
        Weaviate[("Weaviate Vector DB<br/>Port 8080<br/>FraudPattern Vectors")]
    end

    User -->|HTTP :3000 (UI)| Web
    User -->|HTTP :3001 (API)| BFF
    Web -.->|Browser API Calls :3001| BFF

    BFF -->|HTTP :8000 / Internal ai:8000| AI
    BFF -->|TCP :3307 / Internal mysql:3306| MySQL
    BFF -->|HTTP :8080 / Internal weaviate:8080| Weaviate

    classDef client fill:#e2e8f0,stroke:#4a5568,stroke-width:2px;
    classDef web fill:#bee3f8,stroke:#2b6cb0,stroke-width:2px;
    classDef bff fill:#feebc8,stroke:#c05621,stroke-width:2px;
    classDef ai fill:#c6f6d5,stroke:#276749,stroke-width:2px;
    classDef data fill:#fed7d7,stroke:#9b2c2c,stroke-width:2px;

    class User client;
    class Web web;
    class BFF bff;
    class AI ai;
    class MySQL,Weaviate data;
```

## Trust Boundaries & Responsibilities

| Service | Boundary Tier | Host Port | Internal Address | Health Endpoint | Trust Scope & Access Rules |
|---|---|---|---|---|---|
| **Web Shell** | Experience | `3000` | `web:3000` | `/health` | Publicly accessible to analyst browser. Renders UI only; owns zero database credentials. |
| **NestJS BFF** | Orchestration | `3001` | `api:3001` | `/health`, `/health/dependencies` | Public API gateway and boundary owner. Owns Prisma connection to MySQL, proxies AI requests, checks downstream health. |
| **FastAPI AI** | Intelligence | `8000` | `ai:8000` | `/health` | **Private boundary.** Must NEVER be contacted directly by browser. Exposes bounded anomaly scoring contracts to BFF only. |
| **MySQL** | Relational Data | `3307` | `mysql:3306` | TCP Ping / `mysqladmin` | **Private boundary.** Owned strictly by NestJS BFF. Direct browser or external access is forbidden. |
| **Weaviate** | Vector Data | `8080` | `weaviate:8080` | `/v1/.well-known/ready` | **Private boundary.** Stores metadata-filtered fraud patterns. Direct browser access is forbidden. |

## Network Constraints & Addressing
1. **Browser Access**: The browser communicates only with `localhost:3000` (Nuxt) and `localhost:3001` (BFF).
2. **Container Mode**: When run under Docker Compose (`infrastructure/docker-compose.yml`), inter-container communication uses Docker DNS names (`api`, `ai`, `mysql:3306`, `weaviate:8080`).
3. **Local Process Mode**: In the Resource-Constrained Local Profile, communication uses `localhost` / `127.0.0.1` mapped to the specific host ports.
