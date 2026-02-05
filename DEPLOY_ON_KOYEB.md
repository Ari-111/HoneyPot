# 🚀 Deployment Guide: Docker on Koyeb

This guide will help you deploy your **Agentic Honeypot** to Koyeb using Docker. This will provide you with a public HTTPS URL and a secure API key for your hackathon submission.

## ✅ Prerequisites

1. **GitHub Repository**: Your code must be pushed to GitHub (which you have already done).
2. **Koyeb Account**: Sign up at [koyeb.com](https://www.koyeb.com) (Free tier is sufficient).
3. **OpenAI API Key**: You need your `sk-...` key ready.

---

## 🛠️ Step 1: Prepare Repository (Done)

Your project already has the necessary files:
- `Dockerfile`: Configured for Python 3.11 with FastAPI/Uvicorn.
- `requirements.txt`: Lists all dependencies.
- `main.py`: Application entry point.

Ensure your latest changes are pushed to GitHub:
```bash
git add .
git commit -m "Ready for deployment"
git push origin main
```

---

## ☁️ Step 2: Deploy on Koyeb

1. **Login to Koyeb** and go to the **Console**.
2. Click **"Create App"** (or "Create Service").
3. Select **"GitHub"** as the deployment method.
4. Search for and select your repository: `Ari-111/HoneyPot`.
5. **Configure the Service**:
   - **Type**: Web Service
   - **Branch**: `main`
   - **Builder**: `Docker` (Koyeb will automatically detect the Dockerfile).
   - **Instance Type**: `Free` (Nano or Micro is fine).
   - **Regions**: Choose the one closest to you (e.g., Singapore or Frankfurt).

6. **Environment Variables** (Crucial Step):
   Click "Add Variable" and add the following:

   | Key | Value | Description |
   |-----|-------|-------------|
   | `OPENAI_API_KEY` | `sk-proj-...` | Your actual OpenAI API key (Secret) |
   | `API_KEY` | `your-secure-key` | **Create a strong password here.** This will be your `x-api-key` for submission. |
   | `ENVIRONMENT` | `production` | Set environment to production |
   | `PORT` | `8000` | Port the app listens on |

   > **💡 Tip:** For `API_KEY`, choose something unique like `GuviHack2025Secret!` so no one else can spam your API.

7. **Exposed Port**:
   - Ensure the port is set to **8000** in the settings (Under "Ports", map port `8000` to HTTP `/`).

8. Click **"Deploy"**.

---

## 🌍 Step 3: Get Your Deployed Details

Once the deployment status turns **"Healthy"** (green):

1. **Public URL**: You will see a domain like `https://honeypot-api-ari-111.koyeb.app`.
   - **Copy this URL.** This is your `DEPLOYED_URL`.

2. **API Key**: The key you set in step 2 is your `x-api-key`.

---

## 🧪 Step 4: Verify Deployment

You can test your deployed API directly from your terminal:

```powershell
# Replace with your actual Koyeb URL and API Key
$koyebUrl = "https://<YOUR-APP-NAME>.koyeb.app"
$apiKey = "<YOUR-CHOSEN-API-KEY>"

# Test Health
Invoke-RestMethod -Uri "$koyebUrl/health"

# Test Honeypot
$headers = @{"Content-Type"="application/json"; "x-api-key"=$apiKey}
$body = @{
    sessionId = "koyeb-test-1"
    message = @{
        sender = "scammer"
        text = "Urgent! Click this link to confirm bank details"
        timestamp = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
    }
    conversationHistory = @()
    metadata = @{
        channel = "SMS"
        language = "English"
        locale = "IN"
    }
} | ConvertTo-Json -Depth 10

Invoke-RestMethod -Uri "$koyebUrl/api/honeypot" -Method Post -Headers $headers -Body $body -ContentType "application/json"
```

---

## 📤 Hackathon Submission Details

When submitting your project, provide these details:

- **Deployed URL**: `https://<your-app-name>.koyeb.app/api/honeypot`
- **Method**: `POST`
- **Headers**:
  - `Content-Type`: `application/json`
  - `x-api-key`: `(The secure key you set in Env Vars)`
- **Request Body Format**: (Standard JSON as per problem statement)

---

## 🆘 Troubleshooting

- **Deployment Fails?** Check the "Runtime Logs" tab in Koyeb.
- **502 Bad Gateway?** Ensure your `PORT` env var matches the Dockerfile exposed port (8000).
- **401 Unauthorized?** Check if you are sending the correct `x-api-key` header.
