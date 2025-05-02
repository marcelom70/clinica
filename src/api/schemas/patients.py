from pydantic import BaseModel, Field, EmailStr, validator
from typing import Optional, List, Dict, Any
from datetime import date, datetime
import re

class PatientBase(BaseModel):
    """Base patient model with common attributes"""
    name: str = Field(..., min_length=2, max_length=255, description="Patient's full name")
    cpf: Optional[str] = Field(None, min_length=11, max_length=14, description="Brazilian CPF document (format: XXX.XXX.XXX-XX)")
    date_of_birth: date = Field(..., description="Patient's date of birth (YYYY-MM-DD)")
    gender: Optional[str] = Field(None, description="Patient's gender")
    phone: Optional[str] = Field(None, max_length=20, description="Contact phone number")
    email: Optional[str] = Field(None, max_length=100, description="Contact email address")
    address: Optional[str] = Field(None, description="Patient's address")
    insurance_number: Optional[str] = Field(None, max_length=50, description="Health insurance number")
    emergency_contact_name: Optional[str] = Field(None, max_length=100, description="Emergency contact name")
    emergency_contact_phone: Optional[str] = Field(None, max_length=20, description="Emergency contact phone")
    notes: Optional[str] = Field(None, description="Additional notes about the patient")
    health_insurance_id: Optional[int] = Field(None, description="ID of the health insurance plan")

    @validator('cpf')
    def validate_cpf(cls, v):
        """Validate CPF format"""
        if v is not None:
            # Remove non-numeric characters for validation
            numbers = re.sub(r'[^0-9]', '', v)
            if len(numbers) != 11:
                raise ValueError('CPF must have 11 digits')
            
            # Format CPF with dots and dash
            formatted = f"{numbers[:3]}.{numbers[3:6]}.{numbers[6:9]}-{numbers[9:]}"
            return formatted
        return v

    @validator('phone', 'emergency_contact_phone')
    def validate_phone(cls, v):
        """Basic phone validation"""
        if v is not None:
            # Remove non-numeric and common phone characters
            phone_chars = re.sub(r'[^0-9+() -]', '', v)
            if len(phone_chars) < 8:
                raise ValueError('Phone number is too short')
        return v

class PatientCreate(PatientBase):
    """Model used for creating a new patient"""
    pass

class PatientUpdate(BaseModel):
    """Model used for updating an existing patient (all fields optional)"""
    name: Optional[str] = Field(None, min_length=2, max_length=255)
    cpf: Optional[str] = Field(None, min_length=11, max_length=14)
    date_of_birth: Optional[date] = None
    gender: Optional[str] = None
    phone: Optional[str] = Field(None, max_length=20)
    email: Optional[str] = Field(None, max_length=100)
    address: Optional[str] = None
    insurance_number: Optional[str] = Field(None, max_length=50)
    emergency_contact_name: Optional[str] = Field(None, max_length=100)
    emergency_contact_phone: Optional[str] = Field(None, max_length=20)
    notes: Optional[str] = None
    health_insurance_id: Optional[int] = None

    @validator('cpf')
    def validate_cpf(cls, v):
        """Validate CPF format"""
        if v is not None:
            # Remove non-numeric characters for validation
            numbers = re.sub(r'[^0-9]', '', v)
            if len(numbers) != 11:
                raise ValueError('CPF must have 11 digits')
            
            # Format CPF with dots and dash
            formatted = f"{numbers[:3]}.{numbers[3:6]}.{numbers[6:9]}-{numbers[9:]}"
            return formatted
        return v

class Patient(PatientBase):
    """Model for patient responses including database fields"""
    id: int
    uuid: str
    created_at: datetime
    updated_at: datetime

    class Config:
        orm_mode = True

class PatientList(BaseModel):
    """Model for paginated patient list responses"""
    total: int
    items: List[Patient]

class PatientDetail(Patient):
    """Model for detailed patient information including related data"""
    appointments_count: int = 0
    medical_records_count: int = 0
    
    class Config:
        orm_mode = True 