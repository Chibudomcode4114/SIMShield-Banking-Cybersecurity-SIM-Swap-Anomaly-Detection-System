# ==============================================================================
# SIMShield Local Topology Shutdown Script (Windows PowerShell)
# ==============================================================================
# Gracefully stops processes bound to ports 3000, 3001, 8000, 3307, 8080
# ==============================================================================

Write-Host "Stopping SIMShield services..." -ForegroundColor Cyan

$ports = @(3000, 3001, 8000, 3307, 8080)

foreach ($port in $ports) {
    $connections = Get-NetTCPConnection -LocalPort $port -State Listen -ErrorAction SilentlyContinue
    if ($connections) {
        foreach ($conn in $connections) {
            $procId = $conn.OwningProcess
            if ($procId -gt 0) {
                try {
                    $proc = Get-Process -Id $procId -ErrorAction SilentlyContinue
                    if ($proc) {
                        Write-Host "Terminating process $($proc.ProcessName) (PID: $procId) listening on port $port..." -ForegroundColor Yellow
                        Stop-Process -Id $procId -Force -ErrorAction SilentlyContinue
                    }
                } catch {}
            }
        }
    } else {
        Write-Host "Port $port is clear." -ForegroundColor Green
    }
}

Start-Sleep -Seconds 1
Write-Host "All SIMShield ports stopped and cleared." -ForegroundColor Green
