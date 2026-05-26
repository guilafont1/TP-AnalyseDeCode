# Exporte les issues SonarQube locales (après scan)
param(
    [string]$ProjectKey = "tp-analyse-shuttle",
    [string]$HostUrl = "http://localhost:9000",
    [string]$TokenFile = ".sonar-token.local"
)

$token = if ($env:SONAR_TOKEN) { $env:SONAR_TOKEN } else { Get-Content $TokenFile -Raw }
$issues = Invoke-RestMethod -Uri "$HostUrl/api/issues/search?projectKeys=$ProjectKey&ps=500" -Headers @{ Authorization = "Bearer $token" }
Write-Host "Total issues: $($issues.total)"
$issues.issues | Group-Object rule | Sort-Object Count -Descending | ForEach-Object {
    "{0,4} {1}" -f $_.Count, $_.Name
}
