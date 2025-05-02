from fastapi import APIRouter, HTTPException, Query, Path, Depends, status
from typing import List, Optional, Dict, Any
import logging
import sys
import os
from datetime import date, datetime

# Add parent directory to path
sys.path.append(os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))))

# Import database functions
from database.connection import execute_query

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

# Create router
router = APIRouter(
    prefix="/medical-records",
    tags=["medical_records"],
    responses={404: {"description": "Medical record not found"}},
)

@router.get("/patient/{patient_id}")
async def get_patient_medical_records(
    patient_id: int = Path(..., gt=0, description="The ID of the patient"),
    skip: int = Query(0, ge=0, description="Number of records to skip"),
    limit: int = Query(10, ge=1, le=50, description="Maximum number of records to return"),
):
    """
    Get medical records for a specific patient.
    """
    try:
        # Check if patient exists
        patient_query = "SELECT id FROM patients WHERE id = %(patient_id)s"
        patient_result = execute_query(patient_query, {'patient_id': patient_id})
        
        if not patient_result:
            raise HTTPException(
                status_code=404,
                detail=f"Patient with ID {patient_id} not found"
            )
            
        # Get medical records count
        count_query = """
            SELECT COUNT(*) as total
            FROM medical_records
            WHERE patient_id = %(patient_id)s
        """
        
        count_result = execute_query(count_query, {'patient_id': patient_id})
        total = count_result[0]['total'] if count_result else 0
        
        # Get medical records
        query = """
            SELECT mr.id, mr.uuid, mr.patient_id, mr.doctor_id, mr.consultation_date,
                mr.symptoms, mr.diagnosis, mr.treatment, mr.prescription,
                mr.follow_up, mr.notes, mr.digitized_from_physical,
                mr.source_document_reference, mr.ai_summary, mr.created_at, mr.updated_at,
                d.name as doctor_name
            FROM medical_records mr
            JOIN doctors d ON mr.doctor_id = d.id
            WHERE mr.patient_id = %(patient_id)s
            ORDER BY mr.consultation_date DESC, mr.created_at DESC
            LIMIT %(limit)s OFFSET %(skip)s
        """
        
        records = execute_query(query, {
            'patient_id': patient_id,
            'limit': limit,
            'skip': skip
        })
        
        return {
            "total": total,
            "items": records
        }
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error fetching medical records for patient {patient_id}: {str(e)}")
        raise HTTPException(
            status_code=500,
            detail="An error occurred while fetching medical records"
        )

@router.get("/{record_id}")
async def get_medical_record(
    record_id: int = Path(..., gt=0, description="The ID of the medical record to get"),
):
    """
    Get a specific medical record by ID.
    """
    try:
        query = """
            SELECT mr.id, mr.uuid, mr.patient_id, mr.doctor_id, mr.appointment_id,
                mr.consultation_date, mr.symptoms, mr.diagnosis, mr.treatment, mr.prescription,
                mr.follow_up, mr.notes, mr.digitized_from_physical,
                mr.source_document_reference, mr.ai_summary, mr.created_at, mr.updated_at,
                p.name as patient_name, p.date_of_birth, p.gender,
                d.name as doctor_name
            FROM medical_records mr
            JOIN patients p ON mr.patient_id = p.id
            JOIN doctors d ON mr.doctor_id = d.id
            WHERE mr.id = %(record_id)s
        """
        
        result = execute_query(query, {'record_id': record_id})
        
        if not result:
            raise HTTPException(
                status_code=404,
                detail=f"Medical record with ID {record_id} not found"
            )
            
        return result[0]
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error fetching medical record {record_id}: {str(e)}")
        raise HTTPException(
            status_code=500,
            detail="An error occurred while fetching the medical record"
        ) 