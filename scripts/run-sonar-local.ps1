# Lance SonarQube (Docker) + sonar-scanner sur ce projet
# Prérequis : Docker Desktop démarré

$ErrorActionPreference = "Stop"
$ProjectRoot = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
Set-Location $ProjectRoot

Write-Host "==> Demarrage SonarQube local (port 9000)..." -ForegroundColor Cyan
docker compose -f docker-compose.sonar.yml up -d

$statusUrl = "http://localhost:9000/api/system/status"
$deadline = (Get-Date).AddMinutes(5)
Write-Host "==> Attente du serveur SonarQube..." -ForegroundColor Cyan
do {
    Start-Sleep -Seconds 5
    try {
        $status = Invoke-RestMethod -Uri $statusUrl -Method Get -TimeoutSec 10
        if ($status.status -eq "UP") { break }
    } catch {
        Write-Host "." -NoNewline
    }
} while ((Get-Date) -lt $deadline)

if ($status.status -ne "UP") {
    throw "SonarQube n'a pas demarre dans les 5 minutes. Verifiez : docker compose -f docker-compose.sonar.yml logs"
}
Write-Host "`n==> SonarQube UP" -ForegroundColor Green

# Token : variable d'environnement ou argument
$token = $env:SONAR_TOKEN
if (-not $token -and $args.Count -gt 0) { $token = $args[0] }
if (-not $token) {
    Write-Host @"

!!! Token Sonar requis pour le scan !!!
1. Ouvrez http://localhost:9000 (login admin / admin, changez le mot de passe)
2. My Account > Security > Generate Token
3. Relancez :
   `$env:SONAR_TOKEN='votre_token'; .\scripts\run-sonar-local.ps1

Ou SonarCloud :
   `$env:SONAR_TOKEN='token_sonarcloud'; docker run ... (voir README-SONAR.md)

"@ -ForegroundColor Yellow
    exit 1
}

Write-Host "==> Analyse sonar-scanner (projet local)..." -ForegroundColor Cyan
docker run --rm `
    -e SONAR_HOST_URL="http://host.docker.internal:9000" `
    -e SONAR_TOKEN="$token" `
    -v "${ProjectRoot}:/usr/src" `
    -w /usr/src `
    sonarsource/sonar-scanner-cli:latest `
    -Dsonar.projectKey=tp-analyse-shuttle `
    -Dsonar.host.url=http://host.docker.internal:9000 `
    -Dsonar.token=$token `
    -Dsonar.projectName="TP-Analyse de code"

Write-Host "==> Rapport : http://localhost:9000/dashboard?id=tp-analyse-shuttle" -ForegroundColor Green
