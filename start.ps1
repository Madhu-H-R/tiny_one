# ChatGPT AI Platform - One-click startup script
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  ChatGPT AI Platform - Starting..." -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

$rootDir = if ($PSScriptRoot) { $PSScriptRoot } else { (Get-Location).Path }
$backendDir = Join-Path $rootDir "backend"
$frontendDir = Join-Path $rootDir "frontend"

# Locate Python executable
$pythonExe = "python"
if (Test-Path "$backendDir\.venv\Scripts\python.exe") {
    $pythonExe = "$backendDir\.venv\Scripts\python.exe"
} elseif (Test-Path "$rootDir\.venv\Scripts\python.exe") {
    $pythonExe = "$rootDir\.venv\Scripts\python.exe"
}

# Kill anything on ports 8000 and 3000
$ports = @(8000, 3000)
foreach ($port in $ports) {
    $proc = Get-NetTCPConnection -LocalPort $port -ErrorAction SilentlyContinue | Select-Object -ExpandProperty OwningProcess
    if ($proc) { Stop-Process -Id $proc -Force -ErrorAction SilentlyContinue }
}
Get-Process -Name cloudflared -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue

Write-Host "[1/3] Starting FastAPI backend on http://localhost:8000 ..." -ForegroundColor Yellow
Start-Process powershell -ArgumentList "-NoProfile -Command `"Set-Location '$backendDir'; & '$pythonExe' -m uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload`"" -WindowStyle Normal

Start-Sleep -Seconds 3

$cloudflaredPath = Join-Path $rootDir "cloudflared.exe"
if (Test-Path $cloudflaredPath) {
    Write-Host "[2/3] Starting Cloudflare Public Tunnel..." -ForegroundColor Yellow
    Start-Process powershell -ArgumentList "-NoProfile -Command `"Set-Location '$rootDir'; & '$cloudflaredPath' tunnel --url http://localhost:8000`"" -WindowStyle Normal
    Start-Sleep -Seconds 3
} else {
    Write-Host "[2/3] Skipping Cloudflare Tunnel (cloudflared.exe not found)" -ForegroundColor DarkGray
}

Write-Host "[3/3] Starting Next.js frontend on http://localhost:3000 ..." -ForegroundColor Yellow
Start-Process powershell -ArgumentList "-NoProfile -Command `"Set-Location '$frontendDir'; npm.cmd run dev`"" -WindowStyle Normal

Start-Sleep -Seconds 4

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  READY!" -ForegroundColor Green
Write-Host "  Local Web App:    http://localhost:3000" -ForegroundColor Green
Write-Host "  Backend API:      http://localhost:8000" -ForegroundColor Green  
Write-Host "  API Docs:         http://localhost:8000/docs" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green

Start-Process "http://localhost:3000"
