# SIMShield: Banking Cybersecurity & SIM-Swap Anomaly Detection

> **Day 2 Baseline**: Advanced Artifact-Driven Local Environment & Five-Service Topology

---

## 1. Project Mission & Context

### The Bold Idea
**SIMShield** is a risk-based financial cybersecurity MVP designed to detect suspicious SIM/device replacements occurring within telecom channels and empower banks to prevent account takeover (ATO) before fraudulent financial transactions are executed.

### Target Problem & Current Legacy Workflow
In the current banking and telecom ecosystem, SIM card replacement occurs within telecom provider networks, while banks independently handle customer logins, OTP generation, and high-value transactions. This architectural gap means a bank may remain unaware that a customer's SIM has been compromised until an unauthorized wire transfer or withdrawal occurs.

### Named Actors
- **Primary Actor**: **Bank Fraud / Security Analyst** — Needs to immediately assess incoming alerts, examine risk classifications, and intervene before fraudulent funds exit the banking perimeter.
- **Oversight Actor**: **Bank Security Administrator** — Configures risk thresholds, audit logging policies, and compliance reporting.

### Day 1 Success Metric
- **Target**: Detect a simulated SIM/device-change event and return a risk classification in **sub-second latency**, triggering automated transaction holds or step-up authentication on high-risk scenarios.

---

## 2. Five-Service Architecture & Boundaries

SIMShield enforces a strict local-first five-service separation of concerns:

```
[Browser Client]
       │
       ├─────────────────────────────────┐
       ▼ (HTTP :3000)                    ▼ (HTTP :3001)
┌──────────────┐                  ┌──────────────┐
│  Nuxt 3 Web  │                  │  NestJS BFF  │ (Orchestration & Gateway)
│  (apps/web)  │                  │  (apps/api)  │
└──────────────┘                  └──────┬───────┘
                                         │
              ┌──────────────────────────┼──────────────────────────┐
              ▼ (HTTP :8000)             ▼ (TCP :3307)              ▼ (HTTP :8080)
       ┌──────────────┐           ┌──────────────┐           ┌──────────────┐
       │  FastAPI AI  │           │  MySQL 8.0   │           │   Weaviate   │
       │(services/ai) │           │(infrastructure)          │(infrastructure)
       └──────────────┘           └──────────────┘           └──────────────┘
```

| Service | Boundary Tier | Host Port | Runtime | Primary Responsibility |
|---|---|---|---|---|
| **Web Shell** | Experience | `3000` | Nuxt 3 / Vue 3 / TS | Responsive analyst dashboard; strictly holds no database credentials. |
| **NestJS BFF** | Orchestration | `3001` | NestJS 10 / Node 22 | Public API contract; owns Prisma ORM, health contracts, and AI proxies. |
| **FastAPI AI** | Intelligence | `8000` | FastAPI / Python 3.13 | Private boundary; calculates anomaly scores (truthful standby on Day 2). |
| **MySQL 8.0** | Relational Data | `3307` | MySQL / Prisma | Stores bank accounts, SIM-swap events, transaction logs, and audit trails. |
| **Weaviate** | Vector Data | `8080` | Weaviate 1.25.4 | Stores and filters historical fraud patterns for future RAG retrieval. |

---

## 3. Prerequisites & Compute Survival Profile

### System Prerequisites
- **Operating System**: Windows 10/11, macOS, or Linux
- **Node.js**: v20.0+ (Tested on v22.18.0)
- **Python**: 3.11+ (Tested on 3.13.0)
- **Docker & Docker Compose**: (Optional for container mode; tested with Compose v5.5.1)

### Selected Profile: Resource-Constrained Local Profile
Detected host specifications: Intel Core i5 (2 cores, 4 threads), 8GB RAM, ~10GB free disk space. To guarantee reliable local development without continuous cloud connectivity or virtualization overhead, SIMShield runs as lightweight, native processes with validated container definitions in `infrastructure/docker-compose.yml`.

---

## 4. Setup & Quickstart Guide

### Step 1: Environment Configuration
Copy the sanitized environment template into an active `.env` file (which is strictly gitignored):

```powershell
cp .env.example .env
```

### Step 2: Start the Five Services
Run the automated Windows PowerShell startup script:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\start.ps1
```

Or start the containers via Docker Compose (if virtualization is enabled):

```bash
docker compose -f infrastructure/docker-compose.yml up -d
```

### Step 3: Verify Health
Run the automated health check:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\health-check.ps1
```

Expected healthy output:
- `Nuxt Web`: `http://localhost:3000` (Status: `HEALTHY`)
- `NestJS BFF`: `http://localhost:3001/health` (Status: `HEALTHY`)
- `BFF Dependencies`: `http://localhost:3001/health/dependencies` (Status: `HEALTHY`)
- `FastAPI AI`: `http://localhost:8000/health` (Status: `HEALTHY`, capabilities: `standing_by`)
- `MySQL`: Port `3307` (Status: `HEALTHY`)
- `Weaviate`: `http://localhost:8080/v1/.well-known/ready` (Status: `HEALTHY`)

### Step 4: Run Failure & Recovery Verification
Demonstrate that the system detects and cleanly recovers from an induced dependency outage:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\fault-injection.ps1
```

### Step 5: Stop Services
Gracefully stop all running local background services:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\stop.ps1
```

---

## 5. Health Semantics & Truthful Status

SIMShield enforces Phase E truthful health semantics:
- **Healthy**: The component is running and actively satisfies its Day 2 baseline contract.
- **Degraded**: The service is running, but an optional dependency (such as FastAPI AI) is unreachable. Core banking operations remain functional.
- **Unhealthy**: A primary dependency (such as MySQL or Weaviate) is offline; the BFF returns HTTP 503.
- **Truthful Capabilities**: AI routes report `standing_by` and `not_configured`. Day 2 proves boundaries and contracts—it never claims future LLM inference or embeddings are operational before they are built.

---

## 6. Troubleshooting Guidance

| Issue | Root Cause | Resolution |
|---|---|---|
| **Port Conflict (3000, 3001, 8000, 3307, 8080)** | Another application is bound to the port. | Run `Get-NetTCPConnection -LocalPort <port>` and terminate the owning process with `scripts/stop.ps1`. |
| **PowerShell Execution Policy Error** | Script execution restricted by Windows. | Always launch scripts with `-ExecutionPolicy Bypass`, e.g., `powershell -ExecutionPolicy Bypass -File .\scripts\start.ps1`. |
| **Docker Desktop Virtualization Error** | Windows Virtual Machine Platform not enabled. | Use the provided native process profile (`scripts/start.ps1`), or enable virtualization in BIOS and run `dism /online /enable-feature /featurename:VirtualMachinePlatform`. |
| **BFF Reports Degraded** | FastAPI service on port 8000 is stopped. | Run `python services/ai/main.py` to restore the intelligence boundary. |

---

## 7. Data & Secret-Handling Rules

1. **Strictly Synthetic Data**: High-risk financial cybersecurity MVP. Never insert real customer records, real phone numbers, actual banking credentials, or live OTP tokens.
2. **Secret Hygiene**: Real secrets and credentials must reside only in the untracked `.env` file. Committing `.env` or live credentials will fail acceptance gates.

---

## 8. Deferred Components & Day 1 Non-Goals

The following items are intentionally excluded from Day 2:
- ❌ No direct integration with live telecom carriers (MTN, Airtel, Glo, 9mobile).
- ❌ No real bank core-banking integrations or money movement.
- ❌ No live foundation LLM model weights downloaded to disk.
- ❌ No Redis, Neo4j, or external cloud dependencies.

---

## 9. Day 3 Handoff: What is Ready Next

The Day 2 environment establishes the foundation for:
- **Day 3 (Multi-Actor Interfaces)**: Building out the interactive Analyst SIM-Swap event feed, risk threshold controls, and step-up authentication simulators in Nuxt 3.
- **Day 4 (Transactional Core)**: Activating Prisma migrations against MySQL for domain records (`BankAccount`, `SimSwapEvent`, `RiskAssessment`).
