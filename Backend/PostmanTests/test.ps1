# Make new folder \.temp\bin in directory where the script is located
$progressPreference = 'SilentlyContinue'
$binPath = Join-Path $PSScriptRoot ".temp\bin"
$mailhogUrl = "https://github.com/mailhog/MailHog/releases/download/v1.0.1/MailHog_windows_amd64.exe"
$mailhogPath = Join-Path $binPath "MailHog.exe"
$newmanCollectionPath = Join-Path $PSScriptRoot "tests.postman_collection.json"
$newmanEnvironmentPath = Join-Path $PSScriptRoot "tawsilaDevelopment.postman_environment.json"
$testResultsDir = Join-Path $PSScriptRoot "results"
$testResultsPath = Join-Path $testResultsDir "results.html"

if (!(Test-Path $mailhogPath)) {
    Write-Host "Downloading MailHog..."
    New-Item -ItemType Directory -Path $binPath -Force | Out-Null
    Invoke-WebRequest -Uri $mailhogUrl -OutFile $mailhogPath | Out-Null
}

if (!(Get-Command yarn -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Yarn..."
    npm install yarn --no-save | Out-Null
}

Write-Host "Installing dependencies..."
yarn --cwd $PSScriptRoot install --immutable --immutable-cache --check-cache --silent

Write-Host "Starting MailHog..."
Start-Process -FilePath $mailhogPath -WindowStyle Hidden

Write-Host "Waiting for MailHog to start..."
Start-Sleep -Seconds 5

Write-Host "Running tests..."
New-Item -ItemType Directory -Path $testResultsDir -Force | Out-Null
yarn --cwd $PSScriptRoot newman run $newmanCollectionPath -e $newmanEnvironmentPath --insecure -r "cli,htmlextra" --reporter-htmlextra-export $testResultsPath --reporter-htmlextra-darkTheme

Write-Host "Stopping MailHog..."
Get-Process -Name "MailHog" | Stop-Process