from fastapi import APIRouter, HTTPException, Depends, Query, status
from typing import List, Optional, Any
from datetime import datetime
from pydantic import BaseModel, EmailStr, Field

from src.database.connection import execute_query, fetch_one, fetch_all

# Define doctor models
class DoctorBase(BaseModel):
    name: str
    specialization: str
    email: EmailStr
    phone: str

class DoctorCreate(DoctorBase):
    pass

class DoctorUpdate(BaseModel):
    name: Optional[str] = None
    specialization: Optional[str] = None
    email: Optional[EmailStr] = None
    phone: Optional[str] = None

class DoctorResponse(DoctorBase):
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

@router.post("/", response_model=DoctorResponse, status_code=status.HTTP_201_CREATED)
async def create_doctor(doctor: DoctorCreate):
    """Create a new doctor"""
    query = """
        INSERT INTO doctors (name, specialization, email, phone)
        VALUES (%(name)s, %(specialization)s, %(email)s, %(phone)s)
        RETURNING id, name, specialization, email, phone, created_at, updated_at
    """
    result = await fetch_one(
        query,
        {
            "name": doctor.name,
            "specialization": doctor.specialization,
            "email": doctor.email,
            "phone": doctor.phone
        }
    )
    
    if not result:
        raise HTTPException(status_code=500, detail="Failed to create doctor")
    
    return result

@router.get("/{doctor_id}", response_model=DoctorResponse)
async def get_doctor(doctor_id: int):
    """Get a doctor by ID"""
    query = """
        SELECT id, name, specialization, email, phone, created_at, updated_at
        FROM doctors
        WHERE id = %(doctor_id)s
    """
    result = await fetch_one(query, {"doctor_id": doctor_id})
    
    if not result:
        raise HTTPException(status_code=404, detail="Doctor not found")
    
    return result

@router.get("/", response_model=List[DoctorResponse])
async def get_doctors(
    skip: int = Query(0, ge=0),
    limit: int = Query(100, ge=1, le=100),
    specialization: Optional[str] = None
):
    """Get a list of doctors with optional filtering by specialization"""
    query_params = {}
    
    if specialization:
        query = """
            SELECT id, name, specialization, email, phone, created_at, updated_at
            FROM doctors
            WHERE specialization ILIKE %(specialization_filter)s
            ORDER BY name
            LIMIT %(limit)s OFFSET %(skip)s
        """
        query_params["specialization_filter"] = f"%{specialization}%"
    else:
        query = """
            SELECT id, name, specialization, email, phone, created_at, updated_at
            FROM doctors
            ORDER BY name
            LIMIT %(limit)s OFFSET %(skip)s
        """
    
    query_params["limit"] = limit
    query_params["skip"] = skip
    
    results = await fetch_all(query, query_params)
    return results

@router.put("/{doctor_id}", response_model=DoctorResponse)
async def update_doctor(doctor_id: int, doctor: DoctorUpdate):
    """Update a doctor"""
    # First check if doctor exists
    check_query = "SELECT id FROM doctors WHERE id = %(doctor_id)s"
    check_result = await fetch_one(check_query, {"doctor_id": doctor_id})
    
    if not check_result:
        raise HTTPException(status_code=404, detail="Doctor not found")
    
    # Build update query dynamically based on provided fields
    update_fields = []
    params = {"doctor_id": doctor_id}
    
    for field, value in doctor.dict(exclude_unset=True).items():
        if value is not None:
            update_fields.append(f"{field} = %({field})s")
            params[field] = value
    
    if not update_fields:
        # No fields to update
        query = """
            SELECT id, name, specialization, email, phone, created_at, updated_at
            FROM doctors
            WHERE id = %(doctor_id)s
        """
        return await fetch_one(query, {"doctor_id": doctor_id})
    
    # Construct and execute update query
    query = f"""
        UPDATE doctors
        SET {", ".join(update_fields)}
        WHERE id = %(doctor_id)s
        RETURNING id, name, specialization, email, phone, created_at, updated_at
    """
    
    result = await fetch_one(query, params)
    
    if not result:
        raise HTTPException(status_code=500, detail="Failed to update doctor")
    
    return result

@router.delete("/{doctor_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_doctor(doctor_id: int):
    """Delete a doctor"""
    query = "DELETE FROM doctors WHERE id = %(doctor_id)s"
    result = await execute_query(query, {"doctor_id": doctor_id}, fetch=False)
    
    if result is None:
        raise HTTPException(status_code=500, detail="Failed to delete doctor")
    
    return None 