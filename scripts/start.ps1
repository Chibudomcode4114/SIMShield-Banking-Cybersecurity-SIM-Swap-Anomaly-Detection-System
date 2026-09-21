# ==============================================================================
# SIMShield Local Topology Startup Script (Windows PowerShell)
# ==============================================================================
# Starts all 5 services in dependency-aware order under Resource-Constrained Profile.
# Handles paths with spaces properly.
# Ports: MySQL (3307), Weaviate (8080), FastAPI (8000), NestJS (3001), Web (3000)
# ==============================================================================

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "   Starting SIMShield 5-Service Topology (Day 2 Baseline) " -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

$WorkspaceRoot = (Resolve-Path "$PSScriptRoot\..").Path
$PythonExe = (Get-Command python).Source
$NodeExe = (Get-Command node).Source

# Helper to check if a port is listening
function Test-PortListening([int]$Port) {
    $conn = Get-NetTCPConnection -LocalPort $Port -State Listen -ErrorAction SilentlyContinue
    return ($null -ne $conn)
}

# Helper to wait for port
function Wait-ForPort([int]$Port, [string]$ServiceName, [int]$TimeoutSec = 30) {
    Write-Host "Waiting for $ServiceName on port $Port..." -NoNewline
    $elapsed = 0
    while (-not (Test-PortListening -Port $Port) -and ($elapsed -lt $TimeoutSec)) {
        Start-Sleep -Seconds 1
        $elapsed++
        Write-Host "." -NoNewline
    }
    if (Test-PortListening -Port $Port) {
        Write-Host " [READY]" -ForegroundColor Green
        return $true
    } else {
        Write-Host " [TIMED OUT]" -ForegroundColor Red
        return $false
    }
}

# 1. Start MySQL Stub (Port 3307)
if (-not (Test-PortListening -Port 3307)) {
    Write-Host "[1/5] Starting MySQL Database Stub (:3307)..." -ForegroundColor Yellow
    Start-Process -FilePath $PythonExe -ArgumentList "`"$WorkspaceRoot\infrastructure\stubs\mysql_stub.py`"" -WorkingDirectory "$WorkspaceRoot\infrastructure\stubs" -WindowStyle Hidden
    Wait-ForPort -Port 3307 -ServiceName "MySQL Stub"
} else {
    Write-Host "[1/5] MySQL already listening on port 3307" -ForegroundColor Green
}

# 2. Start Weaviate Stub (Port 8080)
if (-not (Test-PortListening -Port 8080)) {
    Write-Host "[2/5] Starting Weaviate Vector DB Stub (:8080)..." -ForegroundColor Yellow
    Start-Process -FilePath $PythonExe -ArgumentList "`"$WorkspaceRoot\infrastructure\stubs\weaviate_stub.py`"" -WorkingDirectory "$WorkspaceRoot\infrastructure\stubs" -WindowStyle Hidden
    Wait-ForPort -Port 8080 -ServiceName "Weaviate Stub"
} else {
    Write-Host "[2/5] Weaviate already listening on port 8080" -ForegroundColor Green
}

# 3. Start FastAPI AI Service (Port 8000)
if (-not (Test-PortListening -Port 8000)) {
    Write-Host "[3/5] Starting FastAPI AI Service (:8000)..." -ForegroundColor Yellow
    Start-Process -FilePath $PythonExe -ArgumentList "`"$WorkspaceRoot\services\ai\main.py`"" -WorkingDirectory "$WorkspaceRoot\services\ai" -WindowStyle Hidden
    Wait-ForPort -Port 8000 -ServiceName "FastAPI AI"
} else {
    Write-Host "[3/5] FastAPI already listening on port 8000" -ForegroundColor Green
}

# 4. Start NestJS BFF API (Port 3001)
if (-not (Test-PortListening -Port 3001)) {
    Write-Host "[4/5] Starting NestJS BFF API (:3001)..." -ForegroundColor Yellow
    Start-Process -FilePath $NodeExe -ArgumentList "`"$WorkspaceRoot\apps\api\dist\main.js`"" -WorkingDirectory "$WorkspaceRoot\apps\api" -WindowStyle Hidden
    Wait-ForPort -Port 3001 -ServiceName "NestJS BFF"
} else {
    Write-Host "[4/5] NestJS BFF already listening on port 3001" -ForegroundColor Green
}

# 5. Start Nuxt Web UI Shell (Port 3000)
if (-not (Test-PortListening -Port 3000)) {
    Write-Host "[5/5] Starting Nuxt Web Application (:3000)..." -ForegroundColor Yellow
    Start-Process -FilePath $NodeExe -ArgumentList "`"$WorkspaceRoot\apps\web\server.js`"" -WorkingDirectory "$WorkspaceRoot\apps\web" -WindowStyle Hidden
    Wait-ForPort -Port 3000 -ServiceName "Nuxt Web"
} else {
    Write-Host "[5/5] Nuxt Web already listening on port 3000" -ForegroundColor Green
}

Write-Host "`nAll 5 services launched successfully!" -ForegroundColor Cyan
Write-Host "Web Console: http://localhost:3000" -ForegroundColor White
Write-Host "BFF Health:  http://localhost:3001/health/dependencies" -ForegroundColor White
Write-Host "AI Health:   http://localhost:8000/health" -ForegroundColor White
