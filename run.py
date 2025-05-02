#!/usr/bin/env python3
import os
import sys
import uvicorn
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

# Get port from environment variable or use default
port = int(os.getenv("PORT", 8080))
host = os.getenv("HOST", "0.0.0.0")
reload_mode = os.getenv("DEBUG", "true").lower() == "true"

# Add the current directory to the Python path
sys.path.insert(0, os.path.abspath("."))

if __name__ == "__main__":
    print(f"Starting server on {host}:{port} (reload mode: {reload_mode})")
    uvicorn.run(
        "src.main:app",
        host=host,
        port=port,
        reload=reload_mode,
        log_level="info",
    ) 