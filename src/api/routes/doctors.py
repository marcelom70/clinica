from fastapi import APIRouter, HTTPException, Query, Path, Depends, status
from typing import List, Optional, Dict, Any
import logging
import sys
import os

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
    prefix="/doctors",
    tags=["doctors"],
    responses={404: {"description": "Doctor not found"}},
)

@router.get("/")
async def get_doctors(
    skip: int = Query(0, ge=0, description="Number of doctors to skip"),
    limit: int = Query(100, ge=1, le=100, description="Maximum number of doctors to return"),
    specialty_id: Optional[int] = Query(None, description="Filter by specialty ID"),
):
    """
    Get a list of doctors with pagination and filtering options.
    """
    try:
        # Build query based on filter parameters
        count_query = "SELECT COUNT(*) as total FROM doctors d"
        query = """
            SELECT d.id, d.uuid, d.name, d.crm, d.phone, d.email,
                d.created_at, d.updated_at
            FROM doctors d
        """
        
        params = {}
        where_clause = []
        
        # Add filter for specialty
        if specialty_id:
            count_query = """
                SELECT COUNT(*) as total FROM doctors d
                JOIN doctor_specialties ds ON d.id = ds.doctor_id
                WHERE ds.specialty_id = %(specialty_id)s
            """
            
            query = """
                SELECT DISTINCT d.id, d.uuid, d.name, d.crm, d.phone, d.email,
                    d.created_at, d.updated_at
                FROM doctors d
                JOIN doctor_specialties ds ON d.id = ds.doctor_id
                WHERE ds.specialty_id = %(specialty_id)s
            """
            
            params['specialty_id'] = specialty_id
            
        # Add pagination
        query += " ORDER BY d.name LIMIT %(limit)s OFFSET %(skip)s"
        params.update({'limit': limit, 'skip': skip})
        
        # Get total count
        count_result = execute_query(count_query, params)
        total = count_result[0]['total'] if count_result else 0
        
        # Get doctors
        doctors = execute_query(query, params)
        
        return {
            "total": total,
            "items": doctors
        }
    except Exception as e:
        logger.error(f"Error fetching doctors: {str(e)}")
        raise HTTPException(
            status_code=500,
            detail="An error occurred while fetching doctors"
        )

@router.get("/{doctor_id}")
async def get_doctor(
    doctor_id: int = Path(..., gt=0, description="The ID of the doctor to get"),
):
    """
    Get detailed information for a specific doctor by ID.
    """
    try:
        # Get doctor details with specialties
        query = """
            SELECT d.id, d.uuid, d.name, d.crm, d.phone, d.email,
                d.created_at, d.updated_at,
                array_agg(DISTINCT s.name) as specialties
            FROM doctors d
            LEFT JOIN doctor_specialties ds ON d.id = ds.doctor_id
            LEFT JOIN specialties s ON ds.specialty_id = s.id
            WHERE d.id = %(doctor_id)s
            GROUP BY d.id
        """
        
        result = execute_query(query, {'doctor_id': doctor_id})
        
        if not result:
            raise HTTPException(
                status_code=404,
                detail=f"Doctor with ID {doctor_id} not found"
            )
            
        return result[0]
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error fetching doctor {doctor_id}: {str(e)}")
        raise HTTPException(
            status_code=500,
            detail="An error occurred while fetching the doctor details"
        ) 