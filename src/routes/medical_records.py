from fastapi import APIRouter, HTTPException, Depends, Query, status, Path
from typing import List, Optional, Any
from datetime import datetime
from pydantic import BaseModel, Field

from src.database.connection import execute_query, fetch_one, fetch_all

# Define medical record models
class MedicalRecordBase(BaseModel):
    patient_id: int
    doctor_id: int
    appointment_id: Optional[int] = None
    diagnosis: str
    treatment: str
    prescription: Optional[str] = None
    notes: Optional[str] = None

class MedicalRecordCreate(MedicalRecordBase):
    pass

class MedicalRecordUpdate(BaseModel):
    diagnosis: Optional[str] = None
    treatment: Optional[str] = None
    prescription: Optional[str] = None
    notes: Optional[str] = None

class MedicalRecordResponse(MedicalRecordBase):
    id: int
    record_date: datetime
    created_at: Any
    updated_at: Any

    class Config:
        from_attributes = True
        json_encoders = {
            datetime: lambda v: v.isoformat()
        }

class MedicalRecordDetailResponse(MedicalRecordResponse):
    patient_name: str
    doctor_name: str

# Create router
router = APIRouter()

@router.post("/", response_model=MedicalRecordResponse, status_code=status.HTTP_201_CREATED)
async def create_medical_record(record: MedicalRecordCreate):
    """Create a new medical record"""
    # Verify patient exists
    patient_check = await fetch_one(
        "SELECT id FROM patients WHERE id = %(patient_id)s",
        {"patient_id": record.patient_id}
    )
    if not patient_check:
        raise HTTPException(status_code=404, detail="Patient not found")
    
    # Verify doctor exists
    doctor_check = await fetch_one(
        "SELECT id FROM doctors WHERE id = %(doctor_id)s",
        {"doctor_id": record.doctor_id}
    )
    if not doctor_check:
        raise HTTPException(status_code=404, detail="Doctor not found")
    
    # Verify appointment exists if provided
    if record.appointment_id:
        appointment_check = await fetch_one(
            "SELECT id FROM appointments WHERE id = %(appointment_id)s",
            {"appointment_id": record.appointment_id}
        )
        if not appointment_check:
            raise HTTPException(status_code=404, detail="Appointment not found")
    
    # Insert medical record
    query = """
        INSERT INTO medical_records (
            patient_id, doctor_id, appointment_id, diagnosis, treatment, 
            prescription, notes, record_date
        )
        VALUES (
            %(patient_id)s, %(doctor_id)s, %(appointment_id)s, %(diagnosis)s, 
            %(treatment)s, %(prescription)s, %(notes)s, CURRENT_TIMESTAMP
        )
        RETURNING id, patient_id, doctor_id, appointment_id, diagnosis, treatment, 
                  prescription, notes, record_date, created_at, updated_at
    """
    result = await fetch_one(
        query,
        {
            "patient_id": record.patient_id,
            "doctor_id": record.doctor_id,
            "appointment_id": record.appointment_id,
            "diagnosis": record.diagnosis,
            "treatment": record.treatment,
            "prescription": record.prescription,
            "notes": record.notes
        }
    )
    
    if not result:
        raise HTTPException(status_code=500, detail="Failed to create medical record")
    
    return result

@router.get("/{record_id}", response_model=MedicalRecordDetailResponse)
async def get_medical_record(record_id: int = Path(..., description="The ID of the medical record")):
    """Get a medical record by ID"""
    query = """
        SELECT 
            mr.id, mr.patient_id, mr.doctor_id, mr.appointment_id, mr.diagnosis, 
            mr.treatment, mr.prescription, mr.notes, mr.record_date, mr.created_at, mr.updated_at,
            p.name as patient_name, d.name as doctor_name
        FROM medical_records mr
        JOIN patients p ON mr.patient_id = p.id
        JOIN doctors d ON mr.doctor_id = d.id
        WHERE mr.id = %(record_id)s
    """
    result = await fetch_one(query, {"record_id": record_id})
    
    if not result:
        raise HTTPException(status_code=404, detail="Medical record not found")
    
    return result

@router.get("/patient/{patient_id}", response_model=List[MedicalRecordDetailResponse])
async def get_patient_medical_records(
    patient_id: int,
    skip: int = Query(0, ge=0),
    limit: int = Query(100, ge=1, le=100)
):
    """Get all medical records for a specific patient"""
    # Verify patient exists
    patient_check = await fetch_one(
        "SELECT id FROM patients WHERE id = %(patient_id)s",
        {"patient_id": patient_id}
    )
    if not patient_check:
        raise HTTPException(status_code=404, detail="Patient not found")
    
    query = """
        SELECT 
            mr.id, mr.patient_id, mr.doctor_id, mr.appointment_id, mr.diagnosis, 
            mr.treatment, mr.prescription, mr.notes, mr.record_date, mr.created_at, mr.updated_at,
            p.name as patient_name, d.name as doctor_name
        FROM medical_records mr
        JOIN patients p ON mr.patient_id = p.id
        JOIN doctors d ON mr.doctor_id = d.id
        WHERE mr.patient_id = %(patient_id)s
        ORDER BY mr.record_date DESC
        LIMIT %(limit)s OFFSET %(skip)s
    """
    
    results = await fetch_all(
        query, 
        {"patient_id": patient_id, "limit": limit, "skip": skip}
    )
    
    return results

@router.put("/{record_id}", response_model=MedicalRecordResponse)
async def update_medical_record(
    record_id: int,
    record: MedicalRecordUpdate
):
    """Update a medical record"""
    # First check if record exists
    check_query = "SELECT id FROM medical_records WHERE id = %(record_id)s"
    check_result = await fetch_one(check_query, {"record_id": record_id})
    
    if not check_result:
        raise HTTPException(status_code=404, detail="Medical record not found")
    
    # Build update query dynamically based on provided fields
    update_fields = []
    params = {"record_id": record_id}
    
    for field, value in record.dict(exclude_unset=True).items():
        if value is not None:
            update_fields.append(f"{field} = %({field})s")
            params[field] = value
    
    if not update_fields:
        # No fields to update
        query = """
            SELECT id, patient_id, doctor_id, appointment_id, diagnosis, treatment, 
                  prescription, notes, record_date, created_at, updated_at
            FROM medical_records
            WHERE id = %(record_id)s
        """
        return await fetch_one(query, {"record_id": record_id})
    
    # Construct and execute update query
    query = f"""
        UPDATE medical_records
        SET {", ".join(update_fields)}
        WHERE id = %(record_id)s
        RETURNING id, patient_id, doctor_id, appointment_id, diagnosis, treatment, 
                  prescription, notes, record_date, created_at, updated_at
    """
    
    result = await fetch_one(query, params)
    
    if not result:
        raise HTTPException(status_code=500, detail="Failed to update medical record")
    
    return result

@router.delete("/{record_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_medical_record(record_id: int):
    """Delete a medical record"""
    query = "DELETE FROM medical_records WHERE id = %(record_id)s"
    result = await execute_query(query, {"record_id": record_id}, fetch=False)
    
    if result is None:
        raise HTTPException(status_code=500, detail="Failed to delete medical record")
    
    return None 