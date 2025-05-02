import os
import sys
import logging
import uvicorn
from fastapi import FastAPI, Request
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse

# Add the parent directory to the Python path
parent_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if parent_dir not in sys.path:
    sys.path.insert(0, parent_dir)

from src.database.connection import init_db, close_db

# Import routes
from src.routes.patients import router as patients_router
from src.routes.doctors import router as doctors_router
from src.routes.appointments import router as appointments_router
from src.routes.medical_records import router as medical_records_router
from src.routes.ai_services import router as ai_services_router

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(name)s - %(levelname)s - %(message)s",
)
logger = logging.getLogger(__name__)

# Create FastAPI app
app = FastAPI(
    title="Clinic Management API",
    description="API for managing a medical clinic",
    version="1.0.0",
)

# Configure CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # For production, specify the exact origins
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Register routers
app.include_router(patients_router, prefix="/api/patients", tags=["Patients"])
app.include_router(doctors_router, prefix="/api/doctors", tags=["Doctors"])
app.include_router(appointments_router, prefix="/api/appointments", tags=["Appointments"])
app.include_router(medical_records_router, prefix="/api/medical-records", tags=["Medical Records"])
app.include_router(ai_services_router, prefix="/api/ai", tags=["AI Services"])

@app.on_event("startup")
async def startup_event():
    """Initialize services on startup."""
    logger.info("Starting up the application")
    await init_db()

@app.on_event("shutdown")
async def shutdown_event():
    """Cleanup resources on shutdown."""
    logger.info("Shutting down the application")
    await close_db()

@app.get("/", tags=["Health"])
async def health_check():
    """Health check endpoint."""
    return {"status": "healthy", "message": "API is running"}

@app.exception_handler(Exception)
async def global_exception_handler(request: Request, exc: Exception):
    """Global exception handler."""
    logger.error(f"Unhandled exception: {str(exc)}")
    return JSONResponse(
        status_code=500,
        content={"message": "An unexpected error occurred", "detail": str(exc)},
    )

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