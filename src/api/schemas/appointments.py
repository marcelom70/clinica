from pydantic import BaseModel, Field, validator
from typing import Optional, List, Dict, Any
from datetime import date, time, datetime
import re

class AppointmentBase(BaseModel):
    """Base appointment model with common attributes"""
    patient_id: int = Field(..., gt=0, description="ID of the patient")
    doctor_id: int = Field(..., gt=0, description="ID of the doctor")
    specialty_id: int = Field(..., gt=0, description="ID of the medical specialty")
    scheduled_date: date = Field(..., description="Date of the appointment (YYYY-MM-DD)")
    scheduled_time: time = Field(..., description="Time of the appointment (HH:MM:SS)")
    duration_minutes: int = Field(30, ge=15, le=180, description="Duration of the appointment in minutes")
    status: str = Field("scheduled", description="Status of the appointment (scheduled, completed, cancelled, no-show)")
    notes: Optional[str] = Field(None, description="Additional notes about the appointment")

    @validator('status')
    def validate_status(cls, v):
        """Validate appointment status"""
        valid_statuses = ["scheduled", "completed", "cancelled", "no-show"]
        if v.lower() not in valid_statuses:
            raise ValueError(f"Status must be one of: {', '.join(valid_statuses)}")
        return v.lower()

class AppointmentCreate(AppointmentBase):
    """Model used for creating a new appointment"""
    pass

class AppointmentUpdate(BaseModel):
    """Model used for updating an existing appointment (all fields optional)"""
    doctor_id: Optional[int] = Field(None, gt=0)
    specialty_id: Optional[int] = Field(None, gt=0)
    scheduled_date: Optional[date] = None
    scheduled_time: Optional[time] = None
    duration_minutes: Optional[int] = Field(None, ge=15, le=180)
    status: Optional[str] = None
    notes: Optional[str] = None

    @validator('status')
    def validate_status(cls, v):
        """Validate appointment status"""
        if v is not None:
            valid_statuses = ["scheduled", "completed", "cancelled", "no-show"]
            if v.lower() not in valid_statuses:
                raise ValueError(f"Status must be one of: {', '.join(valid_statuses)}")
            return v.lower()
        return v

class Appointment(AppointmentBase):
    """Model for appointment responses including database fields"""
    id: int
    uuid: str
    created_at: datetime
    updated_at: datetime

    class Config:
        orm_mode = True

class AppointmentList(BaseModel):
    """Model for paginated appointment list responses"""
    total: int
    items: List[Appointment]

class AppointmentDetail(Appointment):
    """Model for detailed appointment information including related data"""
    patient_name: str
    doctor_name: str
    specialty_name: str

    class Config:
        orm_mode = True 