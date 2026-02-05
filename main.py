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


@app.get("/")
async def root_get():
    """Root GET endpoint"""
    return {
        "message": "Agentic Honeypot API",
        "version": "1.0.0",
        "status": "operational",
        "help": "Send POST requests to /api/honeypot"
    }


@app.post("/")
async def root_post(request: Request):
    """
    Root POST endpoint - Fallback for Guvi Tester
    """
    try:
        body = await request.json()
        
        # Check signature of a honeypot request
        if "sessionId" in body:
            # Validate API key manually
            x_api_key = request.headers.get("x-api-key")
            if not x_api_key:
                x_api_key = request.headers.get("X-API-KEY")
            
            if x_api_key != settings.api_key:
                raise HTTPException(status_code=401, detail="Invalid API key")
            
            # Convert to validation model
            msg_request = MessageRequest(**body)
            
            # Execute honeypot logic
            return await honeypot_endpoint(msg_request, x_api_key=x_api_key)
            
    except Exception as e:
        print(f"Fallback Error: {e}")
        pass
        
    raise HTTPException(status_code=405, detail="Please POST to /api/honeypot")


if __name__ == "__main__":
    import uvicorn
    
    uvicorn.run(
        "main:app",
        host="0.0.0.0",
        port=settings.port,
        reload=settings.environment == "development"
    )
