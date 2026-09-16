# Day 2 Evidence 01: Discovery & Technical Final Checks Report

- **Project Name**: SIMShield
- **MVP Mission**: A risk-based cybersecurity system that detects suspicious SIM/device changes within telecom channels and helps banks prevent account takeover (ATO) before fraudulent transactions are completed.
- **Domain**: Banking Cybersecurity / Fraud Detection
- **Primary Actor**: Bank Fraud / Security Analyst
- **Evaluation Date**: 2026-09-12
- **Evaluator**: Antigravity Technical Assistant

## 1. Measured Machine & Environmental Constraints

| Metric | Measured Value | Architectural Implication |
|---|---|---|
| **Operating System** | Windows 10 Pro (Build 10.0.19045, 64-bit) | PowerShell / Windows scripting required |
| **CPU** | Intel Core i5-5300U @ 2.30GHz (2 Cores, 4 Threads) | Lightweight process orchestration necessary |
| **Physical RAM** | 8.0 GB Total | Conservative memory boundaries per service |
| **Available Storage** | 9.48 GB Free on C:\ | Strict volume management; no large models downloaded |
| **Container Engine** | Docker CLI 29.7.2 / Compose 5.5.1 installed; Linux daemon disabled (Virtual Machine Platform disabled in Windows) | Hybrid / Resource-Constrained Local Profile selected with local stubs for ports 3307 and 8080 |
| **Node.js Toolchain** | Node.js v22.18.0 / npm 10.9.3 | Fully functional for NestJS BFF and Nuxt Web shell |
| **Python Toolchain** | Python 3.13.0 / pip 24.2 | FastAPI, Uvicorn, and socket runners verified |
| **Git Version** | 2.47.1.windows.1 | Git initialized; secret hygiene active |

## 2. Port Conflict Analysis

| Required Port | Assigned Service | Status Prior to Setup | Conflict Resolution |
|---|---|---|---|
| **3000** | Nuxt 3 Web Shell | Available | Bound cleanly |
| **3001** | NestJS BFF API | Available | Bound cleanly |
| **8000** | FastAPI AI Service | Available | Bound cleanly |
| **3307** | MySQL Database | Available | Bound cleanly (avoids standard 3306) |
| **8080** | Weaviate Vector DB | Available | Bound cleanly |

## 3. Selected Compute Survival Profile
- **Profile**: **Resource-Constrained Local Profile (with Demonstration Fallback for Virtualization Limitation)**.
- **Rationale**: While standard Docker Compose definitions (`infrastructure/docker-compose.yml`) are fully authored and syntax-validated, the physical host laptop currently lacks Windows Virtual Machine Platform enablement. To ensure immediate testability and verifiable health contracts, services were launched as native processes with local stubs for MySQL and Weaviate.
- **Discovery Decision**: **Ready with safe assumptions**.
