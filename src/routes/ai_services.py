from fastapi import APIRouter, HTTPException, Depends, Query, status, Body
from typing import List, Optional, Dict, Any
from datetime import datetime
from pydantic import BaseModel, Field
import json
import logging

from src.database.connection import execute_query, fetch_one, fetch_all

# Configure logging
logger = logging.getLogger(__name__)

# Define AI service models
class AnalysisRequest(BaseModel):
    patient_id: int
    medical_record_id: Optional[int] = None
    request_type: str = Field(..., description="Type of analysis (e.g., 'symptom_analysis', 'treatment_recommendation')")
    input_data: Dict[str, Any] = Field(..., description="Data for the AI to analyze")

class AnalysisResponse(BaseModel):
    id: int
    patient_id: int
    medical_record_id: Optional[int] = None
    request_type: str
    status: str
    results: Optional[Dict[str, Any]] = None
    created_at: Any
    updated_at: Any

    class Config:
        from_attributes = True
        json_encoders = {
            datetime: lambda v: v.isoformat()
        }

# Create router
router = APIRouter()

@router.post("/analyze", response_model=AnalysisResponse, status_code=status.HTTP_202_ACCEPTED)
async def request_analysis(analysis: AnalysisRequest):
    """Request an AI analysis of medical data"""
    # Verify patient exists
    patient_check = await fetch_one(
        "SELECT id FROM patients WHERE id = %(patient_id)s",
        {"patient_id": analysis.patient_id}
    )
    if not patient_check:
        raise HTTPException(status_code=404, detail="Patient not found")
    
    # Verify medical record exists if provided
    if analysis.medical_record_id:
        record_check = await fetch_one(
            "SELECT id FROM medical_records WHERE id = %(record_id)s",
            {"record_id": analysis.medical_record_id}
        )
        if not record_check:
            raise HTTPException(status_code=404, detail="Medical record not found")
    
    # Insert analysis request into database
    query = """
        INSERT INTO ai_analysis_requests (
            patient_id, medical_record_id, request_type, input_data, status
        )
        VALUES (
            %(patient_id)s, %(medical_record_id)s, %(request_type)s, %(input_data)s, 'pending'
        )
        RETURNING id, patient_id, medical_record_id, request_type, status, results, created_at, updated_at
    """
    
    result = await fetch_one(
        query,
        {
            "patient_id": analysis.patient_id,
            "medical_record_id": analysis.medical_record_id,
            "request_type": analysis.request_type,
            "input_data": json.dumps(analysis.input_data)  # Convert dict to JSON string
        }
    )
    
    if not result:
        raise HTTPException(status_code=500, detail="Failed to create analysis request")
    
    # Convert results from JSON string to dict if not None
    if result.get("results"):
        result["results"] = json.loads(result["results"])
    
    return result

@router.get("/analysis/{analysis_id}", response_model=AnalysisResponse)
async def get_analysis(analysis_id: int):
    """Get the status and results of an AI analysis request"""
    query = """
        SELECT id, patient_id, medical_record_id, request_type, status, results, created_at, updated_at
        FROM ai_analysis_requests
        WHERE id = %(analysis_id)s
    """
    
    result = await fetch_one(query, {"analysis_id": analysis_id})
    
    if not result:
        raise HTTPException(status_code=404, detail="Analysis request not found")
    
    # Convert results from JSON string to dict if not None
    if result.get("results"):
        logger.info(f"Results: {result['results']}")
        result["results"] = json.loads(result["results"])
    
    return result

@router.get("/patient/{patient_id}/analyses", response_model=List[AnalysisResponse])
async def get_patient_analyses(
    patient_id: int,
    skip: int = Query(0, ge=0),
    limit: int = Query(100, ge=1, le=100),
    status: Optional[str] = None
):
    """Get all AI analysis requests for a specific patient"""
    # Verify patient exists
    patient_check = await fetch_one(
        "SELECT id FROM patients WHERE id = %(patient_id)s",
        {"patient_id": patient_id}
    )
    if not patient_check:
        raise HTTPException(status_code=404, detail="Patient not found")
    
    # Build query
    query_params = {"patient_id": patient_id, "limit": limit, "skip": skip}
    
    if status:
        query = """
            SELECT id, patient_id, medical_record_id, request_type, status, results, created_at, updated_at
            FROM ai_analysis_requests
            WHERE patient_id = %(patient_id)s AND status = %(status)s
            ORDER BY created_at DESC
            LIMIT %(limit)s OFFSET %(skip)s
        """
        query_params["status"] = status
    else:
        query = """
            SELECT id, patient_id, medical_record_id, request_type, status, results, created_at, updated_at
            FROM ai_analysis_requests
            WHERE patient_id = %(patient_id)s
            ORDER BY created_at DESC
            LIMIT %(limit)s OFFSET %(skip)s
        """
    
    results = await fetch_all(query, query_params)
    
    # Convert results from JSON string to dict if not None
    for result in results:
        if result.get("results"):
            result["results"] = json.loads(result["results"])
    
    return results

@router.post("/summarize", response_model=Dict[str, Any])
async def summarize_medical_record(record_id: int = Body(..., embed=True)):
    """Generate an AI summary of a medical record"""
    # Verify medical record exists
    record_query = """
        SELECT mr.id, mr.diagnosis, mr.treatment, mr.prescription, mr.notes,
               p.name as patient_name, p.id as patient_id
        FROM medical_records mr
        JOIN patients p ON mr.patient_id = p.id
        WHERE mr.id = %(record_id)s
    """
    
    record = await fetch_one(record_query, {"record_id": record_id})
    
    if not record:
        raise HTTPException(status_code=404, detail="Medical record not found")
    
    # In a real implementation, you would call an AI service here
    # For now, we'll return a mock summary
    summary = {
        "summary": f"Summary of medical record #{record_id} for patient {record['patient_name']}.",
        "key_points": [
            f"Diagnosis: {record['diagnosis']}",
            f"Treatment: {record['treatment']}",
            "Patient should follow the prescribed treatment plan",
            "Patient should follow up in 2 weeks"
        ],
        "recommendations": [
            "Continue prescribed treatment",
            "Monitor symptoms and report any changes",
            "Schedule follow-up appointment"
        ]
    }
    
    # Store the summary in the database
    analysis_query = """
        INSERT INTO ai_analysis_requests (
            patient_id, medical_record_id, request_type, input_data, status, results
        )
        VALUES (
            %(patient_id)s, %(record_id)s, 'record_summary', %(input_data)s, 'completed', %(results)s
        )
        RETURNING id
    """
    
    await execute_query(
        analysis_query,
        {
            "patient_id": record["patient_id"],
            "record_id": record_id,
            "input_data": json.dumps({"record_id": record_id}),
            "results": json.dumps(summary)
        },
        fetch=False
    )
    
    return summary 