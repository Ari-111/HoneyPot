"""
FastAPI Main Application Entry Point
"""

from fastapi import FastAPI, Request, HTTPException
from fastapi.middleware.cors import CORSMiddleware

from api.routes import router, honeypot_endpoint
from api.middleware import RateLimitMiddleware
from config import settings
from models.session import MessageRequest


# Create FastAPI app
app = FastAPI(
    title="Agentic Honeypot API",
    description="AI-powered scam detection and intelligence extraction system",
    version="1.0.0"
)

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Add rate limiting middleware
app.add_middleware(RateLimitMiddleware)

# Include API routes
app.include_router(router)


@app.api_route("/", methods=["GET", "POST"])
async def root(request: Request):
    """
    Root endpoint - Handles both GET (Status) and POST (Fallback for Guvi Tester)
    """
    if request.method == "POST":
        try:
            body = await request.json()
            # Double check if this looks like the expected payload
            if "sessionId" in body and "message" in body:
                # Validate API key manually
                x_api_key = request.headers.get("x-api-key")
                if not x_api_key:
                    x_api_key = request.headers.get("X-API-KEY")
                
                if x_api_key != settings.api_key:
                    raise HTTPException(status_code=401, detail="Invalid API key")
                
                # Convert to validation model
                msg_request = MessageRequest(**body)
                
                # Execute honeypot logic
                # We call the function directly. The 'x_api_key' param takes the string value.
                return await honeypot_endpoint(msg_request, x_api_key=x_api_key)
                
        except Exception as e:
            # If JSON parsing fails or validation fails, fall through to 405/404 or just return status
            print(f"Root POST Fallback Error: {e}")
            pass
            
        raise HTTPException(status_code=405, detail="Method Not Allowed. Please POST to /api/honeypot")

    # Default GET response
    return {
        "message": "Agentic Honeypot API",
        "version": "1.0.0",
        "status": "operational",
        "endpoints": {
            "honeypot": "/api/honeypot (POST)",
            "detailed": "/api/v1/message (POST)",
            "health": "/health (GET)"
        }
    }


if __name__ == "__main__":
    import uvicorn
    
    uvicorn.run(
        "main:app",
        host="0.0.0.0",
        port=settings.port,
        reload=settings.environment == "development"
    )
