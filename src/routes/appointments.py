from fastapi import APIRouter, HTTPException, Depends, Query, status
from typing import List, Optional, Any
from datetime import datetime, timedelta
from pydantic import BaseModel, Field

from src.database.connection import execute_query, fetch_one, fetch_all

# Define appointment models
class AppointmentBase(BaseModel):
    patient_id: int
    doctor_id: int
    appointment_date: datetime
    reason: str
    status: str = Field(default="scheduled")
    notes: Optional[str] = None

class AppointmentCreate(AppointmentBase):
    pass

class AppointmentUpdate(BaseModel):
    appointment_date: Optional[datetime] = None
    reason: Optional[str] = None
    status: Optional[str] = None
    notes: Optional[str] = None

class AppointmentResponse(AppointmentBase):
    id: int
    created_at: Any
    updated_at: Any

    class Config:
        from_attributes = True
        json_encoders = {
            datetime: lambda v: v.isoformat()
        }

class AppointmentDetailResponse(AppointmentResponse):
    patient_name: str
    doctor_name: str
    specialization: str

# Create router
router = APIRouter()

@router.post("/", response_model=AppointmentResponse, status_code=status.HTTP_201_CREATED)
async def create_appointment(appointment: AppointmentCreate):
    """Create a new appointment"""
    # Verify patient exists
    patient_check = await fetch_one(
        "SELECT id FROM patients WHERE id = %(patient_id)s",
        {"patient_id": appointment.patient_id}
    )
    if not patient_check:
        raise HTTPException(status_code=404, detail="Patient not found")
    
    # Verify doctor exists
    doctor_check = await fetch_one(
        "SELECT id FROM doctors WHERE id = %(doctor_id)s",
        {"doctor_id": appointment.doctor_id}
    )
    if not doctor_check:
        raise HTTPException(status_code=404, detail="Doctor not found")
    
    # Check for conflicting appointments
    conflict_check = await fetch_one("""
        SELECT id FROM appointments 
        WHERE doctor_id = %(doctor_id)s 
        AND appointment_date BETWEEN %(appt_start)s AND %(appt_end)s
    """, {
        "doctor_id": appointment.doctor_id,
        "appt_start": appointment.appointment_date - datetime.timedelta(minutes=30),
        "appt_end": appointment.appointment_date + datetime.timedelta(minutes=30)
    })
    
    if conflict_check:
        raise HTTPException(
            status_code=409, 
            detail="Appointment time conflicts with an existing appointment"
        )
    
    # Insert appointment
    query = """
        INSERT INTO appointments (
            patient_id, doctor_id, appointment_date, reason, status, notes
        )
        VALUES (
            %(patient_id)s, %(doctor_id)s, %(appointment_date)s, 
            %(reason)s, %(status)s, %(notes)s
        )
        RETURNING id, patient_id, doctor_id, appointment_date, reason, status, notes, created_at, updated_at
    """
    result = await fetch_one(
        query,
        {
            "patient_id": appointment.patient_id,
            "doctor_id": appointment.doctor_id,
            "appointment_date": appointment.appointment_date,
            "reason": appointment.reason,
            "status": appointment.status,
            "notes": appointment.notes
        }
    )
    
    if not result:
        raise HTTPException(status_code=500, detail="Failed to create appointment")
    
    return result

@router.get("/{appointment_id}", response_model=AppointmentDetailResponse)
async def get_appointment(appointment_id: int):
    """Get appointment details by ID"""
    query = """
        SELECT 
            a.id, a.patient_id, a.doctor_id, a.appointment_date, a.reason, 
            a.status, a.notes, a.created_at, a.updated_at,
            p.name as patient_name, d.name as doctor_name, d.specialization
        FROM appointments a
        JOIN patients p ON a.patient_id = p.id
        JOIN doctors d ON a.doctor_id = d.id
        WHERE a.id = %(appointment_id)s
    """
    result = await fetch_one(query, {"appointment_id": appointment_id})
    
    if not result:
        raise HTTPException(status_code=404, detail="Appointment not found")
    
    return result

@router.get("/", response_model=List[AppointmentDetailResponse])
async def get_appointments(
    skip: int = Query(0, ge=0),
    limit: int = Query(100, ge=1, le=100),
    patient_id: Optional[int] = None,
    doctor_id: Optional[int] = None,
    status: Optional[str] = None,
    date_from: Optional[datetime] = None,
    date_to: Optional[datetime] = None
):
    """Get a list of appointments with optional filtering"""
    query_parts = ["""
        SELECT 
            a.id, a.patient_id, a.doctor_id, a.appointment_date, a.reason, 
            a.status, a.notes, a.created_at, a.updated_at,
            p.name as patient_name, d.name as doctor_name, d.specialization
        FROM appointments a
        JOIN patients p ON a.patient_id = p.id
        JOIN doctors d ON a.doctor_id = d.id
    """]
    
    conditions = []
    params = {"limit": limit, "skip": skip}
    
    if patient_id:
        conditions.append("a.patient_id = %(patient_id)s")
        params["patient_id"] = patient_id
    
    if doctor_id:
        conditions.append("a.doctor_id = %(doctor_id)s")
        params["doctor_id"] = doctor_id
    
    if status:
        conditions.append("a.status = %(status)s")
        params["status"] = status
    
    if date_from:
        conditions.append("a.appointment_date >= %(date_from)s")
        params["date_from"] = date_from
    
    if date_to:
        conditions.append("a.appointment_date <= %(date_to)s")
        params["date_to"] = date_to
    
    if conditions:
        query_parts.append("WHERE " + " AND ".join(conditions))
    
    query_parts.append("ORDER BY a.appointment_date")
    query_parts.append("LIMIT %(limit)s OFFSET %(skip)s")
    
    query = " ".join(query_parts)
    results = await fetch_all(query, params)
    
    return results

@router.put("/{appointment_id}", response_model=AppointmentResponse)
async def update_appointment(appointment_id: int, appointment: AppointmentUpdate):
    """Update an appointment"""
    # First check if appointment exists
    check_query = "SELECT id FROM appointments WHERE id = %(appointment_id)s"
    check_result = await fetch_one(check_query, {"appointment_id": appointment_id})
    
    if not check_result:
        raise HTTPException(status_code=404, detail="Appointment not found")
    
    # Build update query dynamically based on provided fields
    update_fields = []
    params = {"appointment_id": appointment_id}
    
    for field, value in appointment.dict(exclude_unset=True).items():
        if value is not None:
            update_fields.append(f"{field} = %({field})s")
            params[field] = value
    
    if not update_fields:
        # No fields to update
        query = """
            SELECT id, patient_id, doctor_id, appointment_date, reason, status, notes, created_at, updated_at
            FROM appointments
            WHERE id = %(appointment_id)s
        """
        return await fetch_one(query, {"appointment_id": appointment_id})
    
    # Construct and execute update query
    query = f"""
        UPDATE appointments
        SET {", ".join(update_fields)}
        WHERE id = %(appointment_id)s
        RETURNING id, patient_id, doctor_id, appointment_date, reason, status, notes, created_at, updated_at
    """
    
    result = await fetch_one(query, params)
    
    if not result:
        raise HTTPException(status_code=500, detail="Failed to update appointment")
    
    return result

@router.delete("/{appointment_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_appointment(appointment_id: int):
    """Delete an appointment"""
    query = "DELETE FROM appointments WHERE id = %(appointment_id)s"
    result = await execute_query(query, {"appointment_id": appointment_id}, fetch=False)
    
    if result is None:
        raise HTTPException(status_code=500, detail="Failed to delete appointment")
    
    return None 