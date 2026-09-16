# ADR-001: Adoption of Five-Service Local-First Architecture for SIMShield

## Status
**ACCEPTED** (2026-09-12)

## Context
SIMShield is a risk-based cybersecurity system designed for banks to detect suspicious SIM/device changes within telecom channels before fraudulent banking transactions can complete. 

The primary user is a **Bank Fraud / Security Analyst** who needs real-time visibility into incoming SIM replacement events correlated with high-risk financial transactions.

To satisfy the 19-day MVP goals without compromising on security, privacy, or technical rigor, an architecture must:
1. Provide responsive web interactions for analysts without coupling the frontend directly to databases or raw AI models.
2. Establish a clear trust boundary (BFF) to orchestrate authentication, business logic, transaction holds, and audit logging.
3. Isolate AI scoring models and future RAG pipelines into a dedicated service that can evolve independently of transactional banking logic.
4. Separate structured relational customer records (MySQL) from unstructured similarity search (Weaviate).
5. Function reliably on a local machine with constrained hardware (8GB RAM, Core i5, limited internet).

## Decision
We adopt a **Five-Service Architecture**:
1. **Nuxt 3 (apps/web)** on port `3000`: Experience shell for fraud analysts.
2. **NestJS (apps/api)** on port `3001`: Backend-For-Frontend (BFF) owning orchestration, Prisma ORM, and the browser API gateway.
3. **FastAPI (services/ai)** on port `8000`: Dedicated service for SIM anomaly scoring and future LLM/RAG integration.
4. **MySQL 8.0 (infrastructure/mysql)** on port `3307`: Transactional relational store for bank accounts, events, and audit logs.
5. **Weaviate (infrastructure/weaviate)** on port `8080`: Vector database for historical fraud pattern retrieval.

## Deferred Capabilities & Explicit Non-Goals
1. **No Live Foundation Models on Day 2**: AI routes return truthful `standing_by` and `not_configured` statuses.
2. **No Direct Bank/Telco API Integrations**: Synthetic events only.
3. **No External Cloud Storage or Redis Caches**: Minimizes resource consumption on 8GB RAM development laptops.

## Consequences
- **Positive**: Strict isolation of concerns; security boundaries are visible from Day 2; reproducible across both Docker Compose and Resource-Constrained local profiles.
- **Negative / Trade-offs**: Multiple runtimes (Node.js 22 + Python 3.13) require disciplined startup scripting and port coordination.
