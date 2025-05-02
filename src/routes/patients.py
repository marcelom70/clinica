from fastapi import APIRouter, HTTPException, Depends, Query, status
from typing import List, Optional, Any
from datetime import date, datetime
from pydantic import BaseModel, EmailStr, Field

from src.database.connection import execute_query, fetch_one, fetch_all

# Define patient models
class PatientBase(BaseModel):
    name: str
    date_of_birth: date
    gender: str
    email: Optional[EmailStr] = None
    phone: str = Field(..., description="Patient's contact phone number")
    address: Optional[str] = None
    insurance_info: Optional[str] = None

class PatientCreate(PatientBase):
    pass

class PatientUpdate(BaseModel):
    name: Optional[str] = None
    date_of_birth: Optional[date] = None
    gender: Optional[str] = None
    email: Optional[EmailStr] = None
    phone: Optional[str] = None
    address: Optional[str] = None
    insurance_info: Optional[str] = None

class PatientResponse(PatientBase):
    id: int
    created_at: Any
    updated_at: Any

    class Config:
        from_attributes = True
        json_encoders = {
            datetime: lambda v: v.isoformat()
        }

# Create router
router = APIRouter()

@router.post("/", response_model=PatientResponse, status_code=status.HTTP_201_CREATED)
async def create_patient(patient: PatientCreate):
    """Create a new patient"""
    query = """
        INSERT INTO patients (name, date_of_birth, gender, email, phone, address, insurance_info)
        VALUES (%(name)s, %(date_of_birth)s, %(gender)s, %(email)s, %(phone)s, %(address)s, %(insurance_info)s)
        RETURNING id, name, date_of_birth, gender, email, phone, address, insurance_info, created_at, updated_at
    """
    result = await fetch_one(
        query,
        {
            "name": patient.name,
            "date_of_birth": patient.date_of_birth,
            "gender": patient.gender,
            "email": patient.email,
            "phone": patient.phone,
            "address": patient.address,
            "insurance_info": patient.insurance_info
        }
    )
    
    if not result:
        raise HTTPException(status_code=500, detail="Failed to create patient")
    
    return result

@router.get("/{patient_id}", response_model=PatientResponse)
async def get_patient(patient_id: int):
    """Get a patient by ID"""
    query = """
        SELECT id, name, date_of_birth, gender, email, phone, address, insurance_info, created_at, updated_at
        FROM patients
        WHERE id = %(patient_id)s
    """
    result = await fetch_one(query, {"patient_id": patient_id})
    
    if not result:
        raise HTTPException(status_code=404, detail="Patient not found")
    
    return result

@router.get("/", response_model=List[PatientResponse])
async def get_patients(
    skip: int = Query(0, ge=0),
    limit: int = Query(100, ge=1, le=100),
    name: Optional[str] = None
):
    """Get a list of patients with optional filtering by name"""
    query_params = {}
    
    if name:
        query = """
            SELECT id, name, date_of_birth, gender, email, phone, address, insurance_info, created_at, updated_at
            FROM patients
            WHERE name ILIKE %(name_filter)s
            ORDER BY name
            LIMIT %(limit)s OFFSET %(skip)s
        """
        query_params["name_filter"] = f"%{name}%"
    else:
        query = """
            SELECT id, name, date_of_birth, gender, email, phone, address, insurance_info, created_at, updated_at
            FROM patients
            ORDER BY name
            LIMIT %(limit)s OFFSET %(skip)s
        """
    
    query_params["limit"] = limit
    query_params["skip"] = skip
    
    results = await fetch_all(query, query_params)
    return results

@router.put("/{patient_id}", response_model=PatientResponse)
async def update_patient(patient_id: int, patient: PatientUpdate):
    """Update a patient"""
    # First check if patient exists
    check_query = "SELECT id FROM patients WHERE id = %(patient_id)s"
    check_result = await fetch_one(check_query, {"patient_id": patient_id})
    
    if not check_result:
        raise HTTPException(status_code=404, detail="Patient not found")
    
    # Build update query dynamically based on provided fields
    update_fields = []
    params = {"patient_id": patient_id}
    
    for field, value in patient.dict(exclude_unset=True).items():
        if value is not None:
            update_fields.append(f"{field} = %({field})s")
            params[field] = value
    
    if not update_fields:
        # No fields to update
        query = """
            SELECT id, name, date_of_birth, gender, email, phone, address, insurance_info, created_at, updated_at
            FROM patients
            WHERE id = %(patient_id)s
        """
        return await fetch_one(query, {"patient_id": patient_id})
    
    # Construct and execute update query
    query = f"""
        UPDATE patients
        SET {", ".join(update_fields)}
        WHERE id = %(patient_id)s
        RETURNING id, name, date_of_birth, gender, email, phone, address, insurance_info, created_at, updated_at
    """
    
    result = await fetch_one(query, params)
    
    if not result:
        raise HTTPException(status_code=500, detail="Failed to update patient")
    
    return result

@router.delete("/{patient_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_patient(patient_id: int):
    """Delete a patient"""
    query = "DELETE FROM patients WHERE id = %(patient_id)s"
    result = await execute_query(query, {"patient_id": patient_id}, fetch=False)
    
    if result is None:
        raise HTTPException(status_code=500, detail="Failed to delete patient")
    
    return None 