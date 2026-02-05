# Final Verification Test for Deployed API
$deployedUrl = "https://fellow-deb-honeypotttt-4ef83c26.koyeb.app"
$apiKey = "gayguys6969"

Write-Host "=== TESTING DEPLOYED HONEYPOT ===" -ForegroundColor Cyan
Write-Host "URL: $deployedUrl" -ForegroundColor Yellow
Write-Host "Key: $apiKey" -ForegroundColor Yellow

$headers = @{
    "Content-Type" = "application/json"
    "x-api-key" = $apiKey
}

# 1. Health Check
Write-Host "`n[1] Checking Health..." -ForegroundColor Cyan
try {
    $health = Invoke-RestMethod -Uri "$deployedUrl/health" -Method Get
    Write-Host "✅ Health Check Passed: $($health.status)" -ForegroundColor Green
} catch {
    Write-Host "❌ Health Check Failed: $_" -ForegroundColor Red
}

# 2. Test Scam Detection
Write-Host "`n[2] Testing Scam Detection..." -ForegroundColor Cyan
$body = @{
    sessionId = "koyeb-test-final"
    message = @{
        sender = "scammer"
        text = "URGENT: Your KYC is expired. Click here to verify: http://fake-bank-login.com"
        timestamp = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
    }
    conversationHistory = @()
    metadata = @{
        channel = "SMS"
        language = "English"
        locale = "IN"
    }
} | ConvertTo-Json -Depth 10

try {
    $response = Invoke-RestMethod -Uri "$deployedUrl/api/honeypot" -Method Post -Headers $headers -Body $body -ContentType "application/json"
    
    if ($response.scamDetected -eq $true) {
        Write-Host "✅ SUCESS! Scam Detected." -ForegroundColor Green
        Write-Host "   Reply: $($response.reply)" -ForegroundColor Gray
        Write-Host "   Agent Notes: $($response.agentNotes)" -ForegroundColor Gray
    } else {
        Write-Host "⚠️ Warning: Loop detected but scam flag was false." -ForegroundColor Yellow
    }
} catch {
    Write-Host "❌ Test Failed: $_" -ForegroundColor Red
    if ($_.Exception.Response) {
        Write-Host "   Status Code: $($_.Exception.Response.StatusCode)" -ForegroundColor Red
        $stream = $_.Exception.Response.GetResponseStream()
        $reader = New-Object System.IO.StreamReader($stream)
        Write-Host "   Details: $($reader.ReadToEnd())" -ForegroundColor Red
    }
}
