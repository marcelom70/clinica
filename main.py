import os
from src.main import app
import uvicorn

if __name__ == "__main__":
    # Get port from environment variable or use default
    port = int(os.getenv("PORT", 8000))
    
    # Run server
    uvicorn.run(
        "src.main:app",
        host="0.0.0.0",
        port=port,
        reload=True,
        log_level="info",
    ) 