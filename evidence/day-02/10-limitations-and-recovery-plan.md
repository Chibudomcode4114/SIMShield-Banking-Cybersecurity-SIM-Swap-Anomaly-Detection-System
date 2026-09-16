# Day 2 Evidence 10: Limitations & Recovery Plan

- **Project**: SIMShield
- **Date**: 2026-09-12
- **Decision Category**: **CONDITIONAL PASS** (In accordance with Section 16 of the Technical Final Checks Acceptance Gate)

## 1. Observed Limitations vs. Untested Assumptions

### Observed Limitation (Factual)
- **Limitation**: Docker Desktop cannot initialize its Linux VM daemon on this host Windows machine because the Windows `Virtual Machine Platform` feature is currently disabled in the host OS / BIOS (`engine linux/wsl failed to start: checking preconditions: Virtual Machine Platform not enabled`).
- **Impact on Day 2**: While the full `infrastructure/docker-compose.yml` file is authored and passes structural syntax validation (`docker compose config`), container instances could not be spawned natively without enabling virtualization.
- **Approved Fallback Implemented**: The **Resource-Constrained Demonstration Fallback Profile** was activated. Native Node.js and Python processes were launched across all five designated host ports (`3000`, `3001`, `8000`, `3307`, `8080`), and full health contracts, dependency probes, and fault injection were verified end-to-end.

### Untested Assumptions (To be validated in future days)
- **Assumption 1**: The local CPU (Intel Core i5-5300U) will support local quantized embedding models during Days 12-15 without exceeding 8GB RAM. (Validation needed on Day 12).
- **Assumption 2**: Simulated telecom SIM-swap webhook latency will remain under 100ms when processing synthetic event streams. (Validation needed on Day 4).

## 2. Recovery Plan for Container Virtualization

| Field | Entry |
|---|---|
| **Limitation ID** | LIM-01: Windows Virtual Machine Platform Disabled |
| **Owner** | Student / System Administrator |
| **Action Required** | 1. Enable **Virtualization Technology (VT-x / AMD-V)** in BIOS settings.<br/>2. In Windows PowerShell (as Admin), run: `dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart`.<br/>3. Install or update WSL2 (`wsl --update`).<br/>4. Launch Docker Desktop and run `docker compose -f infrastructure/docker-compose.yml up -d`. |
| **Evidence Required** | Output of `docker ps` showing all five containers (`simshield-web`, `simshield-api`, `simshield-ai`, `simshield-mysql`, `simshield-weaviate`) in healthy state. |
| **Deadline** | Prior to Day 4 integration (Transactional Core). |
| **Interim Status** | Safe to proceed: Native process baseline satisfies all Day 3 UI interface contracts without blocking. |
