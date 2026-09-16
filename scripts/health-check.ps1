# ==============================================================================
# SIMShield Automated Topology Health Check (Windows PowerShell)
# ==============================================================================
# Verifies all five service boundaries, endpoints, and health semantics.
# ==============================================================================

Write-Host "`n========================================================" -ForegroundColor Cyan
Write-Host "   SIMShield 5-Service Topology Health Verification     " -ForegroundColor Cyan
Write-Host "========================================================`n" -ForegroundColor Cyan

$Results = @()

# 1. Nuxt Web (3000)
try {
    $sw = [System.Diagnostics.Stopwatch]::StartNew()
    $resp = Invoke-RestMethod -Uri "http://127.0.0.1:3000/health" -Method Get -TimeoutSec 3
    $sw.Stop()
    $Results += [PSCustomObject]@{
        Service = "Web UI (Nuxt 3)"
        Port = 3000
        Status = $resp.status.ToUpper()
        LatencyMs = $sw.ElapsedMilliseconds
        Details = "Role: Fraud Analyst Console Shell"
    }
} catch {
    $Results += [PSCustomObject]@{
        Service = "Web UI (Nuxt 3)"
        Port = 3000
        Status = "FAILED"
        LatencyMs = 0
        Details = $_.Exception.Message
    }
}

# 2. NestJS BFF Self Health (3001)
try {
    $sw = [System.Diagnostics.Stopwatch]::StartNew()
    $resp = Invoke-RestMethod -Uri "http://127.0.0.1:3001/health" -Method Get -TimeoutSec 3
    $sw.Stop()
    $Results += [PSCustomObject]@{
        Service = "BFF API (NestJS)"
        Port = 3001
        Status = $resp.status.ToUpper()
        LatencyMs = $sw.ElapsedMilliseconds
        Details = "Self-health endpoint verified"
    }
} catch {
    $Results += [PSCustomObject]@{
        Service = "BFF API (NestJS)"
        Port = 3001
        Status = "FAILED"
        LatencyMs = 0
        Details = $_.Exception.Message
    }
}

# 3. FastAPI AI Service (8000)
try {
    $sw = [System.Diagnostics.Stopwatch]::StartNew()
    $resp = Invoke-RestMethod -Uri "http://127.0.0.1:8000/health" -Method Get -TimeoutSec 3
    $sw.Stop()
    $Results += [PSCustomObject]@{
        Service = "AI Service (FastAPI)"
        Port = 8000
        Status = $resp.status.ToUpper()
        LatencyMs = $sw.ElapsedMilliseconds
        Details = "Capabilities: standing_by (Truthful Day 2)"
    }
} catch {
    $Results += [PSCustomObject]@{
        Service = "AI Service (FastAPI)"
        Port = 8000
        Status = "FAILED"
        LatencyMs = 0
        Details = $_.Exception.Message
    }
}

# 4. MySQL Database (3307)
try {
    $sw = [System.Diagnostics.Stopwatch]::StartNew()
    $tcp = New-Object System.Net.Sockets.TcpClient
    $tcp.Connect("127.0.0.1", 3307)
    $sw.Stop()
    $tcp.Close()
    $Results += [PSCustomObject]@{
        Service = "MySQL Database"
        Port = 3307
        Status = "HEALTHY"
        LatencyMs = $sw.ElapsedMilliseconds
        Details = "TCP Handshake / Port active"
    }
} catch {
    $Results += [PSCustomObject]@{
        Service = "MySQL Database"
        Port = 3307
        Status = "FAILED"
        LatencyMs = 0
        Details = $_.Exception.Message
    }
}

# 5. Weaviate Vector Database (8080)
try {
    $sw = [System.Diagnostics.Stopwatch]::StartNew()
    $resp = Invoke-WebRequest -Uri "http://127.0.0.1:8080/v1/.well-known/ready" -Method Get -TimeoutSec 3
    $sw.Stop()
    $statusText = if ($resp.StatusCode -eq 200) { "HEALTHY" } else { "DEGRADED" }
    $Results += [PSCustomObject]@{
        Service = "Weaviate Vector DB"
        Port = 8080
        Status = $statusText
        LatencyMs = $sw.ElapsedMilliseconds
        Details = "Route /v1/.well-known/ready passed"
    }
} catch {
    $Results += [PSCustomObject]@{
        Service = "Weaviate Vector DB"
        Port = 8080
        Status = "FAILED"
        LatencyMs = 0
        Details = $_.Exception.Message
    }
}

# Output Table
$Results | Format-Table -AutoSize

# 6. Check BFF Aggregated Dependency Report
Write-Host "Probing BFF Aggregated Dependency Contract (/health/dependencies)..." -ForegroundColor Cyan
try {
    $depResp = Invoke-RestMethod -Uri "http://127.0.0.1:3001/health/dependencies" -Method Get -TimeoutSec 3
    Write-Host "Aggregated Status: $($depResp.status.ToUpper())" -ForegroundColor Green
    Write-Host "Truthful Statement: $($depResp.truthfulStatement)" -ForegroundColor Gray
    Write-Host "Downstream Dependencies:" -ForegroundColor White
    $depResp.dependencies | Format-Custom
} catch {
    Write-Host "Could not query BFF dependencies: $($_.Exception.Message)" -ForegroundColor Red
}

$allHealthy = ($Results | Where-Object { $_.Status -ne "HEALTHY" -and $_.Status -ne "ONLINE" }).Count -eq 0
if ($allHealthy) {
    Write-Host "`n>> TECHNICAL CHECK: ALL 5 SERVICES OPERATIONAL <<" -ForegroundColor Green
    exit 0
} else {
    Write-Host "`n>> TECHNICAL CHECK: ONE OR MORE SERVICES NOT HEALTHY <<" -ForegroundColor Red
    exit 1
}
