import os
import uvicorn
from fastapi import FastAPI, HTTPException, Depends, Query, Path, status
from fastapi.middleware.cors import CORSMiddleware
from typing import List, Optional, Dict, Any
from datetime import date, datetime, timedelta
import json
import logging

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

# Import route modules - these will be created in separate files
from api.routes import patients, appointments, medical_records, doctors, ai_services

# Create FastAPI app
app = FastAPI(
    title="Clínica Médica API",
    description="API para o sistema da clínica médica com digitalização de prontuários e inteligência artificial",
    version="1.0.0"
)

# Configure CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # In production, specify actual origins
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include routers from other modules
app.include_router(patients.router)
app.include_router(appointments.router)
app.include_router(medical_records.router)
app.include_router(doctors.router)
app.include_router(ai_services.router)

@app.get("/")
async def root():
    """Root endpoint, provides basic API information"""
    return {
        "name": "Clínica Médica API",
        "version": "1.0.0",
        "status": "online",
        "docs_url": "/docs"
    }

@app.get("/health")
async def health_check():
    """Health check endpoint for monitoring"""
    return {
        "status": "healthy",
        "timestamp": datetime.now().isoformat(),
        "environment": os.getenv("APP_ENV", "development")
    }

if __name__ == "__main__":
    # Run the API with uvicorn when executed directly
    uvicorn.run(
        "main:app",
        host="0.0.0.0",
        port=int(os.getenv("PORT", 8000)),
        reload=os.getenv("APP_ENV") == "development"
    ) 