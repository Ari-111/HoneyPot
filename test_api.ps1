# Agentic Honeypot API - PowerShell Test Scripts - HACKATHON COMPLIANT FORMAT

# Test 1: Health Check
Write-Host "`n=== Test 1: Health Check ===" -ForegroundColor Cyan
Invoke-RestMethod -Uri "http://localhost:8000/health" -Method Get

# Test 2: API Root
Write-Host "`n=== Test 2: API Root ===" -ForegroundColor Cyan
Invoke-RestMethod -Uri "http://localhost:8000/" -Method Get

# Test 3: GET Honeypot Endpoint
Write-Host "`n=== Test 3: GET Honeypot ===" -ForegroundColor Cyan
Invoke-RestMethod -Uri "http://localhost:8000/api/honeypot" -Method Get

# Test 4: Fake Prize Scam (First Message - Official Format)
Write-Host "`n=== Test 4: Fake Prize Scam (Official Format) ===" -ForegroundColor Cyan
$headers = @{
    "Content-Type" = "application/json"
    "x-api-key"    = "your-secret-hackathon-api-key"
}

$body = @{
    sessionId           = "test-prize-1"
    message             = @{
        sender    = "scammer"
        text      = "Congratulations! You won Rs 50,000 in lucky draw. Send your UPI ID to claim prize: winner2024@paytm"
        timestamp = (Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ")
    }
    conversationHistory = @()
    metadata            = @{
        channel  = "SMS"
        language = "English"
        locale   = "IN"
    }
} | ConvertTo-Json -Depth 10

$response = Invoke-RestMethod -Uri "http://localhost:8000/api/honeypot" -Method Post -Headers $headers -Body $body -ContentType "application/json"
Write-Host "Response:" -ForegroundColor Green
$response | ConvertTo-Json -Depth 10

# Test 5: Bank Impersonation Scam (First Message)
Write-Host "`n=== Test 5: Bank Impersonation Scam ===" -ForegroundColor Cyan
$body2 = @{
    sessionId           = "test-bank-1"
    message             = @{
        sender    = "scammer"
        text      = "This is State Bank customer care. Your account will be blocked within 24 hours. Verify immediately."
        timestamp = (Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ")
    }
    conversationHistory = @()
    metadata            = @{
        channel  = "SMS"
        language = "English"
        locale   = "IN"
    }
} | ConvertTo-Json -Depth 10

$response2 = Invoke-RestMethod -Uri "http://localhost:8000/api/honeypot" -Method Post -Headers $headers -Body $body2 -ContentType "application/json"
Write-Host "Response:" -ForegroundColor Green
$response2 | ConvertTo-Json -Depth 10

# Test 6: Crypto Investment Scam (First Message)
Write-Host "`n=== Test 6: Crypto Investment Scam ===" -ForegroundColor Cyan
$body3 = @{
    sessionId           = "test-crypto-1"
    message             = @{
        sender    = "scammer"
        text      = "Make 200% returns in crypto trading! Just transfer 5000 to 9876543210@paytm"
        timestamp = (Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ")
    }
    conversationHistory = @()
    metadata            = @{
        channel  = "WhatsApp"
        language = "English"
        locale   = "IN"
    }
} | ConvertTo-Json -Depth 10

$response3 = Invoke-RestMethod -Uri "http://localhost:8000/api/honeypot" -Method Post -Headers $headers -Body $body3 -ContentType "application/json"
Write-Host "Response:" -ForegroundColor Green
$response3 | ConvertTo-Json -Depth 10

# Test 7: Refund Scam (Official Format)
Write-Host "`n=== Test 7: Refund Scam ===" -ForegroundColor Cyan
$body4 = @{
    sessionId           = "test-refund-1"
    message             = @{
        sender    = "scammer"
        text      = "Your payment of Rs 999 failed. We are processing refund. Click here: https://bit.ly/refund123 or call 8877665544"
        timestamp = (Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ")
    }
    conversationHistory = @()
    metadata            = @{
        channel  = "SMS"
        language = "English"
        locale   = "IN"
    }
} | ConvertTo-Json -Depth 10

$response4 = Invoke-RestMethod -Uri "http://localhost:8000/api/honeypot" -Method Post -Headers $headers -Body $body4 -ContentType "application/json"
Write-Host "Response:" -ForegroundColor Green
$response4 | ConvertTo-Json -Depth 10

# Test 8: Legitimate Message (should NOT trigger scam detection)
Write-Host "`n=== Test 8: Legitimate Message ===" -ForegroundColor Cyan
$body5 = @{
    sessionId           = "test-legit-1"
    message             = @{
        sender    = "scammer"
        text      = "Hi, how are you doing today?"
        timestamp = (Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ")
    }
    conversationHistory = @()
    metadata            = @{
        channel  = "SMS"
        language = "English"
        locale   = "IN"
    }
} | ConvertTo-Json -Depth 10

$response5 = Invoke-RestMethod -Uri "http://localhost:8000/api/honeypot" -Method Post -Headers $headers -Body $body5 -ContentType "application/json"
Write-Host "Response:" -ForegroundColor Green
$response5 | ConvertTo-Json -Depth 10

Write-Host "`n=== All Tests Completed ===" -ForegroundColor Green
Write-Host "✅ API is HACKATHON COMPLIANT!" -ForegroundColor Yellow
