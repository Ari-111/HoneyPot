# Quick API Test for Hackathon Submission
Write-Host "`n=== HONEYPOT API TESTING ===" -ForegroundColor Cyan
Write-Host "Server: http://localhost:8000" -ForegroundColor Yellow
Write-Host "`nWaiting for server to be ready..." -ForegroundColor Gray
Start-Sleep -Seconds 2

$headers = @{
    "Content-Type" = "application/json"
    "x-api-key"    = "your-secret-hackathon-api-key"
}

# Test 1: Health Check
Write-Host "`n[1/4] Testing Health Endpoint..." -ForegroundColor Cyan
try {
    $health = Invoke-RestMethod -Uri "http://localhost:8000/health" -Method Get
    Write-Host "✅ Health Check: $($health.status)" -ForegroundColor Green
    Write-Host "   Database: $($health.database)" -ForegroundColor Gray
    Write-Host "   Personas: $($health.personas_loaded)" -ForegroundColor Gray
}
catch {
    Write-Host "❌ Health check failed: $_" -ForegroundColor Red
}

# Test 2: Fake Prize Scam
Write-Host "`n[2/4] Testing Fake Prize Scam Detection..." -ForegroundColor Cyan
$body1 = @{
    sessionId           = "test-prize-001"
    message             = @{
        sender    = "scammer"
        text      = "Congratulations! You won Rs 50,000! Send UPI ID to claim: winner2024@paytm"
        timestamp = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
    }
    conversationHistory = @()
    metadata            = @{
        channel  = "SMS"
        language = "English"
        locale   = "IN"
    }
} | ConvertTo-Json -Depth 10

try {
    $response1 = Invoke-RestMethod -Uri "http://localhost:8000/api/honeypot" -Method Post -Headers $headers -Body $body1 -ContentType "application/json"
    Write-Host "✅ Scam Detected: $($response1.scamDetected)" -ForegroundColor Green
    Write-Host "   Persona Reply: $($response1.reply.Substring(0, [Math]::Min(80, $response1.reply.Length)))..." -ForegroundColor Gray
    Write-Host "   UPI IDs Found: $($response1.extractedIntelligence.upiIds.Count)" -ForegroundColor Gray
    Write-Host "   Messages Exchanged: $($response1.engagementMetrics.totalMessagesExchanged)" -ForegroundColor Gray
}
catch {
    Write-Host "❌ Test failed: $_" -ForegroundColor Red
    Write-Host $_.Exception.Response.StatusCode -ForegroundColor Red
}

# Test 3: UPI Collection Scam
Write-Host "`n[3/4] Testing UPI Collection Scam..." -ForegroundColor Cyan
$body2 = @{
    sessionId           = "test-upi-002"
    message             = @{
        sender    = "scammer"
        text      = "Your bank account will be blocked! Verify immediately by sending payment to 9876543210@paytm"
        timestamp = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
    }
    conversationHistory = @()
    metadata            = @{
        channel  = "WhatsApp"
        language = "English"
        locale   = "IN"
    }
} | ConvertTo-Json -Depth 10

try {
    $response2 = Invoke-RestMethod -Uri "http://localhost:8000/api/honeypot" -Method Post -Headers $headers -Body $body2 -ContentType "application/json"
    Write-Host "✅ Scam Detected: $($response2.scamDetected)" -ForegroundColor Green
    Write-Host "   Phone Numbers Found: $($response2.extractedIntelligence.phoneNumbers.Count)" -ForegroundColor Gray
    Write-Host "   Suspicious Keywords: $($response2.extractedIntelligence.suspiciousKeywords.Count)" -ForegroundColor Gray
}
catch {
    Write-Host "❌ Test failed: $_" -ForegroundColor Red
}

# Test 4: Multi-turn Conversation
Write-Host "`n[4/4] Testing Multi-turn Conversation..." -ForegroundColor Cyan
$body3 = @{
    sessionId           = "test-prize-001"
    message             = @{
        sender    = "scammer"
        text      = "Just send me your name and phone number to claim the prize"
        timestamp = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
    }
    conversationHistory = @(
        @{
            sender    = "scammer"
            text      = "You won Rs 50,000!"
            timestamp = (Get-Date).AddMinutes(-2).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
        },
        @{
            sender    = "agent"
            text      = "Really? How did I win?"
            timestamp = (Get-Date).AddMinutes(-1).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
        }
    )
    metadata            = @{
        channel  = "SMS"
        language = "English"
        locale   = "IN"
    }
} | ConvertTo-Json -Depth 10

try {
    $response3 = Invoke-RestMethod -Uri "http://localhost:8000/api/honeypot" -Method Post -Headers $headers -Body $body3 -ContentType "application/json"
    Write-Host "✅ Multi-turn Response Generated" -ForegroundColor Green
    Write-Host "   Total Messages: $($response3.engagementMetrics.totalMessagesExchanged)" -ForegroundColor Gray
    Write-Host "   Engagement Duration: $($response3.engagementMetrics.engagementDurationSeconds)s" -ForegroundColor Gray
}
catch {
    Write-Host "❌ Test failed: $_" -ForegroundColor Red
}

Write-Host "`n=== TESTING COMPLETE ===" -ForegroundColor Cyan
Write-Host "`n📋 Summary for Hackathon Submission:" -ForegroundColor Yellow
Write-Host "   API Endpoint: http://localhost:8000/api/honeypot" -ForegroundColor White
Write-Host "   API Key Header: x-api-key" -ForegroundColor White
Write-Host "   Health Check: http://localhost:8000/health" -ForegroundColor White
Write-Host "   Documentation: http://localhost:8000/docs" -ForegroundColor White
Write-Host "--- TEST COMPLETED ---" -ForegroundColor Green
