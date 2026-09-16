# Day 2 Evidence 09: Repository Status & Change Summary

- **Project**: SIMShield
- **Date**: 2026-09-12

## 1. Files Deliberately Preserved
- `Day_2_Advanced_Artifact_Driven_Local_Environment_Master_Agent_Prompt.docx`: Student-supplied master specification and input sheet was preserved unmodified.
- `~$y_2_Advanced_Artifact_Driven_Local_Environment_Master_Agent_Prompt.docx`: Lockfile preserved.

## 2. Directory Structure & Files Created

```text
C:\G1 19 Day Project\
├── .gitignore                                 # Secret and build ignore definitions
├── .env.example                               # Sanitized environment template
├── .env                                       # Local active configuration (strictly untracked)
├── package.json                               # Root workspace configuration
├── README.md                                  # Reproduction and troubleshooting documentation
│
├── apps/
│   ├── web/                                   # Nuxt 3 Web Shell (Port 3000)
│   │   ├── package.json
│   │   ├── nuxt.config.ts
│   │   ├── app.vue
│   │   ├── server.js
│   │   └── Dockerfile
│   └── api/                                   # NestJS BFF & Orchestration (Port 3001)
│       ├── package.json
│       ├── tsconfig.json
│       ├── Dockerfile
│       ├── prisma/schema.prisma
│       └── src/
│           ├── main.ts
│           ├── app.module.ts
│           └── health/
│               ├── health.controller.ts
│               └── health.service.ts
│
├── services/
│   └── ai/                                    # FastAPI AI Boundary (Port 8000)
│       ├── requirements.txt
│       ├── main.py
│       └── Dockerfile
│
├── infrastructure/                            # Container & Local Fallback Assets
│   ├── docker-compose.yml                     # Validated 5-service container topology
│   ├── mysql/init.sql                         # MySQL schema and synthetic seed data
│   └── stubs/
│       ├── mysql_stub.py                      # Local TCP handshake listener (Port 3307)
│       └── weaviate_stub.py                   # Local Weaviate HTTP readiness stub (Port 8080)
│
├── scripts/                                   # Cross-Platform Automation Tooling
│   ├── start.ps1                              # 5-service startup coordinator
│   ├── stop.ps1                               # Safe shutdown utility
│   ├── health-check.ps1                       # Automated health and dependency probe
│   └── fault-injection.ps1                    # Non-destructive fault injection harness
│
├── docs/                                      # Architecture Decision Records & Maps
│   ├── topology.md                            # Network boundaries & trust diagram
│   ├── service-register.md                    # Port, owner, and endpoint register
│   ├── adr-001-five-service-topology.md       # Architecture Decision Record
│   ├── environment-manifest.json              # Resolved runtime & toolchain manifest
│   └── changelog.md                           # Record of baseline adaptations
│
└── evidence/day-02/                           # Timestamped Auditable Evidence Pack
    ├── 01-discovery-and-final checks-report.md
    ├── 02-topology-diagram.md
    ├── 03-service-and-port-register.md
    ├── 04-environment-manifest.json
    ├── 05-compose-orchestration-validation.log
    ├── 06-health-and-connectivity-report.md
    ├── 07-fault-injection-report.md
    ├── 08-secret-hygiene-report.md
    ├── 09-repository-status-and-change-summary.md
    └── 10-limitations-and-recovery-plan.md
```

## 3. Git Status Summary
- Git branch: `master`
- All changes are contained within `C:\G1 19 Day Project`.
- No unapproved destructive actions or deletions occurred.
