from fastapi import APIRouter, HTTPException, Query, Path, Depends, status
from typing import List, Optional, Dict, Any
import logging
import sys
import os
from datetime import date, datetime

# Add parent directory to path
sys.path.append(os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))))

# Import schemas and database functions
from api.schemas.patients import Patient, PatientCreate, PatientUpdate, PatientList, PatientDetail
from database.connection import execute_query

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

# Create router
router = APIRouter(
    prefix="/patients",
    tags=["patients"],
    responses={404: {"description": "Patient not found"}},
)

@router.get("/", response_model=PatientList)
async def get_patients(
    skip: int = Query(0, ge=0, description="Number of patients to skip"),
    limit: int = Query(100, ge=1, le=100, description="Maximum number of patients to return"),
    search: Optional[str] = Query(None, description="Search term for patient name or CPF"),
):
    """
    Get a list of patients with pagination and optional search.
    """
    try:
        # Build query based on search parameters
        count_query = "SELECT COUNT(*) as total FROM patients"
        query = """
            SELECT id, uuid, name, cpf, date_of_birth, gender, phone, email, 
                address, health_insurance_id, insurance_number, emergency_contact_name, 
                emergency_contact_phone, notes, created_at, updated_at
            FROM patients
        """
        
        params = {}
        where_clause = []
        
        # Add search conditions if provided
        if search:
            where_clause.append("(name ILIKE %(search)s OR cpf ILIKE %(search)s)")
            params['search'] = f"%{search}%"
            
        # Add WHERE clause if conditions exist
        if where_clause:
            query += " WHERE " + " AND ".join(where_clause)
            count_query += " WHERE " + " AND ".join(where_clause)
            
        # Add pagination
        query += " ORDER BY name LIMIT %(limit)s OFFSET %(skip)s"
        params.update({'limit': limit, 'skip': skip})
        
        # Get total count
        count_result = execute_query(count_query, params)
        total = count_result[0]['total'] if count_result else 0
        
        # Get patients
        patients = execute_query(query, params)
        
        return {
            "total": total,
            "items": patients
        }
    except Exception as e:
        logger.error(f"Error fetching patients: {str(e)}")
        raise HTTPException(
            status_code=500,
            detail="An error occurred while fetching patients"
        )

@router.get("/exact-name", response_model=PatientList)
async def find_patient_by_exact_name(
    name: str = Query(..., description="Exact patient name to search for")
):
    """Find patients by exact name match"""
    try:
        query = """
            SELECT id, uuid, name, cpf, date_of_birth, gender, phone, email, 
                address, health_insurance_id, insurance_number, emergency_contact_name, 
                emergency_contact_phone, notes, created_at, updated_at
            FROM patients
            WHERE name = %(name)s
            ORDER BY id
            LIMIT 10
        """
        results = execute_query(query, {"name": name})
        
        return {
            "total": len(results),
            "items": results
        }
    except Exception as e:
        logger.error(f"Error finding patients by exact name: {str(e)}")
        raise HTTPException(
            status_code=500,
            detail="An error occurred while searching for patients"
        )

@router.get("/{patient_id}", response_model=PatientDetail)
async def get_patient(
    patient_id: int = Path(..., gt=0, description="The ID of the patient to get"),
):
    """
    Get detailed information for a specific patient by ID.
    """
    try:
        # Get patient details
        query = """
            SELECT p.id, p.uuid, p.name, p.cpf, p.date_of_birth, p.gender, p.phone, p.email, 
                p.address, p.health_insurance_id, p.insurance_number, p.emergency_contact_name, 
                p.emergency_contact_phone, p.notes, p.created_at, p.updated_at,
                (SELECT COUNT(*) FROM appointments WHERE patient_id = p.id) as appointments_count,
                (SELECT COUNT(*) FROM medical_records WHERE patient_id = p.id) as medical_records_count
            FROM patients p
            WHERE p.id = %(patient_id)s
        """
        
        result = execute_query(query, {'patient_id': patient_id})
        
        if not result:
            raise HTTPException(
                status_code=404,
                detail=f"Patient with ID {patient_id} not found"
            )
            
        return result[0]
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error fetching patient {patient_id}: {str(e)}")
        raise HTTPException(
            status_code=500,
            detail="An error occurred while fetching the patient details"
        )

@router.post("/", response_model=Patient, status_code=status.HTTP_201_CREATED)
async def create_patient(
    patient: PatientCreate,
):
    """
    Create a new patient.
    """
    try:
        # Check if patient with the same CPF already exists
        if patient.cpf:
            check_query = "SELECT id FROM patients WHERE cpf = %(cpf)s"
            check_result = execute_query(check_query, {'cpf': patient.cpf})
            
            if check_result:
                raise HTTPException(
                    status_code=400,
                    detail=f"Patient with CPF {patient.cpf} already exists"
                )
        
        # Insert new patient
        query = """
            INSERT INTO patients (
                name, cpf, date_of_birth, gender, phone, email, address, 
                health_insurance_id, insurance_number, emergency_contact_name, 
                emergency_contact_phone, notes
            ) VALUES (
                %(name)s, %(cpf)s, %(date_of_birth)s, %(gender)s, %(phone)s, %(email)s, 
                %(address)s, %(health_insurance_id)s, %(insurance_number)s, 
                %(emergency_contact_name)s, %(emergency_contact_phone)s, %(notes)s
            )
            RETURNING id, uuid, name, cpf, date_of_birth, gender, phone, email, 
                address, health_insurance_id, insurance_number, emergency_contact_name, 
                emergency_contact_phone, notes, created_at, updated_at
        """
        
        params = patient.dict()
        result = execute_query(query, params)
        
        return result[0]
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error creating patient: {str(e)}")
        raise HTTPException(
            status_code=500,
            detail="An error occurred while creating the patient"
        )

@router.put("/{patient_id}", response_model=Patient)
async def update_patient(
    patient: PatientUpdate,
    patient_id: int = Path(..., gt=0, description="The ID of the patient to update"),
):
    """
    Update an existing patient.
    """
    try:
        # Check if patient exists
        check_query = "SELECT id FROM patients WHERE id = %(patient_id)s"
        check_result = execute_query(check_query, {'patient_id': patient_id})
        
        if not check_result:
            raise HTTPException(
                status_code=404,
                detail=f"Patient with ID {patient_id} not found"
            )
        
        # Check CPF uniqueness if provided
        if patient.cpf:
            cpf_query = "SELECT id FROM patients WHERE cpf = %(cpf)s AND id != %(patient_id)s"
            cpf_result = execute_query(cpf_query, {'cpf': patient.cpf, 'patient_id': patient_id})
            
            if cpf_result:
                raise HTTPException(
                    status_code=400,
                    detail=f"Patient with CPF {patient.cpf} already exists"
                )
        
        # Build update query dynamically
        update_fields = []
        params = {'patient_id': patient_id}
        
        # Only include non-None fields in the update
        patient_dict = patient.dict(exclude_unset=True)
        for key, value in patient_dict.items():
            if value is not None:
                update_fields.append(f"{key} = %({key})s")
                params[key] = value
        
        if not update_fields:
            # If no fields to update, just return the patient
            query = """
                SELECT id, uuid, name, cpf, date_of_birth, gender, phone, email, 
                    address, health_insurance_id, insurance_number, emergency_contact_name, 
                    emergency_contact_phone, notes, created_at, updated_at
                FROM patients
                WHERE id = %(patient_id)s
            """
        else:
            # Build and execute update query
            query = f"""
                UPDATE patients
                SET {", ".join(update_fields)}
                WHERE id = %(patient_id)s
                RETURNING id, uuid, name, cpf, date_of_birth, gender, phone, email, 
                    address, health_insurance_id, insurance_number, emergency_contact_name, 
                    emergency_contact_phone, notes, created_at, updated_at
            """
        
        result = execute_query(query, params)
        return result[0]
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error updating patient {patient_id}: {str(e)}")
        raise HTTPException(
            status_code=500,
            detail="An error occurred while updating the patient"
        )

@router.delete("/{patient_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_patient(
    patient_id: int = Path(..., gt=0, description="The ID of the patient to delete"),
):
    """
    Delete a patient.
    
    Note: This will fail if the patient has related records (appointments, medical records)
    due to foreign key constraints, unless cascading is set up.
    """
    try:
        # Check if patient has related records
        check_query = """
            SELECT 
                (SELECT COUNT(*) FROM appointments WHERE patient_id = %(patient_id)s) as appointments_count,
                (SELECT COUNT(*) FROM medical_records WHERE patient_id = %(patient_id)s) as records_count
        """
        check_result = execute_query(check_query, {'patient_id': patient_id})
        
        if check_result and (check_result[0]['appointments_count'] > 0 or check_result[0]['records_count'] > 0):
            raise HTTPException(
                status_code=400,
                detail="Cannot delete patient with existing appointments or medical records"
            )
        
        # Delete the patient
        query = "DELETE FROM patients WHERE id = %(patient_id)s RETURNING id"
        result = execute_query(query, {'patient_id': patient_id})
        
        if not result:
            raise HTTPException(
                status_code=404,
                detail=f"Patient with ID {patient_id} not found"
            )
        
        return None
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error deleting patient {patient_id}: {str(e)}")
        raise HTTPException(
            status_code=500,
            detail="An error occurred while deleting the patient"
        ) 