# Day 2 Evidence 02: Topology & Trust Boundary Diagram

```mermaid
flowchart TD
    subgraph ClientZone ["Browser & Client Boundary (Host Access)"]
        User["Bank Fraud / Security Analyst<br/>(Primary Actor)"]
    end

    subgraph ExperienceZone ["Experience Boundary (:3000)"]
        Web["Nuxt 3 Web Shell<br/>apps/web<br/>Vue 3 + TypeScript"]
    end

    subgraph OrchestrationZone ["Orchestration Boundary (:3001)"]
        BFF["NestJS BFF Gateway<br/>apps/api<br/>Node.js 22 + Prisma"]
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

    BFF -->|HTTP :8000 (Private Contract)| AI
    BFF -->|TCP :3307 (Private Store)| MySQL
    BFF -->|HTTP :8080 (Private Retrieval)| Weaviate

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

## Boundary Isolation Proof
1. **Experience Shell (Nuxt 3)**: Renders analyst console only. Receives public BFF responses. Holds no database secrets or credentials.
2. **Orchestration Gateway (NestJS BFF)**: Coordinates all client API traffic. Strictly isolates database connections from public exposure.
3. **Intelligence Boundary (FastAPI)**: Private to BFF. Exposes minimal anomaly scoring routes.
4. **Data Isolation**: MySQL and Weaviate ports are never exposed to browser directly.
