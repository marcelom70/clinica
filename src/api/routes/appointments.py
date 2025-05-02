from fastapi import APIRouter, HTTPException, Query, Path, Depends, status
from typing import List, Optional, Dict, Any
import logging
import sys
import os
from datetime import date, datetime, time, timedelta

# Add parent directory to path
sys.path.append(os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))))

# Import schemas and database functions
from api.schemas.appointments import Appointment, AppointmentCreate, AppointmentUpdate, AppointmentList, AppointmentDetail
from database.connection import execute_query

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

# Create router
router = APIRouter(
    prefix="/appointments",
    tags=["appointments"],
    responses={404: {"description": "Appointment not found"}},
)

@router.get("/", response_model=AppointmentList)
async def get_appointments(
    skip: int = Query(0, ge=0, description="Number of appointments to skip"),
    limit: int = Query(100, ge=1, le=100, description="Maximum number of appointments to return"),
    patient_id: Optional[int] = Query(None, description="Filter by patient ID"),
    doctor_id: Optional[int] = Query(None, description="Filter by doctor ID"),
    specialty_id: Optional[int] = Query(None, description="Filter by specialty ID"),
    start_date: Optional[date] = Query(None, description="Filter by start date (inclusive)"),
    end_date: Optional[date] = Query(None, description="Filter by end date (inclusive)"),
    status: Optional[str] = Query(None, description="Filter by appointment status"),
):
    """
    Get a list of appointments with pagination and filtering options.
    """
    try:
        # Build query based on filter parameters
        count_query = "SELECT COUNT(*) as total FROM appointments a"
        query = """
            SELECT a.id, a.uuid, a.patient_id, a.doctor_id, a.specialty_id, 
                a.scheduled_date, a.scheduled_time, a.duration_minutes, a.status, 
                a.notes, a.created_at, a.updated_at
            FROM appointments a
        """
        
        params = {}
        where_clause = []
        
        # Add filter conditions if provided
        if patient_id:
            where_clause.append("a.patient_id = %(patient_id)s")
            params['patient_id'] = patient_id
            
        if doctor_id:
            where_clause.append("a.doctor_id = %(doctor_id)s")
            params['doctor_id'] = doctor_id
            
        if specialty_id:
            where_clause.append("a.specialty_id = %(specialty_id)s")
            params['specialty_id'] = specialty_id
            
        if start_date:
            where_clause.append("a.scheduled_date >= %(start_date)s")
            params['start_date'] = start_date
            
        if end_date:
            where_clause.append("a.scheduled_date <= %(end_date)s")
            params['end_date'] = end_date
            
        if status:
            where_clause.append("a.status = %(status)s")
            params['status'] = status
            
        # Add WHERE clause if conditions exist
        if where_clause:
            query += " WHERE " + " AND ".join(where_clause)
            count_query += " WHERE " + " AND ".join(where_clause)
            
        # Add pagination and ordering
        query += " ORDER BY a.scheduled_date DESC, a.scheduled_time ASC LIMIT %(limit)s OFFSET %(skip)s"
        params.update({'limit': limit, 'skip': skip})
        
        # Get total count
        count_result = execute_query(count_query, params)
        total = count_result[0]['total'] if count_result else 0
        
        # Get appointments
        appointments = execute_query(query, params)
        
        return {
            "total": total,
            "items": appointments
        }
    except Exception as e:
        logger.error(f"Error fetching appointments: {str(e)}")
        raise HTTPException(
            status_code=500,
            detail="An error occurred while fetching appointments"
        )

@router.get("/{appointment_id}", response_model=AppointmentDetail)
async def get_appointment(
    appointment_id: int = Path(..., gt=0, description="The ID of the appointment to get"),
):
    """
    Get detailed information for a specific appointment by ID.
    """
    try:
        # Get appointment details with patient, doctor, and specialty information
        query = """
            SELECT a.id, a.uuid, a.patient_id, a.doctor_id, a.specialty_id, 
                a.scheduled_date, a.scheduled_time, a.duration_minutes, a.status, 
                a.notes, a.created_at, a.updated_at,
                p.name as patient_name, d.name as doctor_name, s.name as specialty_name
            FROM appointments a
            JOIN patients p ON a.patient_id = p.id
            JOIN doctors d ON a.doctor_id = d.id
            JOIN specialties s ON a.specialty_id = s.id
            WHERE a.id = %(appointment_id)s
        """
        
        result = execute_query(query, {'appointment_id': appointment_id})
        
        if not result:
            raise HTTPException(
                status_code=404,
                detail=f"Appointment with ID {appointment_id} not found"
            )
            
        return result[0]
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error fetching appointment {appointment_id}: {str(e)}")
        raise HTTPException(
            status_code=500,
            detail="An error occurred while fetching the appointment details"
        )

@router.post("/", response_model=Appointment, status_code=status.HTTP_201_CREATED)
async def create_appointment(
    appointment: AppointmentCreate,
):
    """
    Create a new appointment.
    """
    try:
        # Validate entities existence
        validate_query = """
            SELECT 
                (SELECT COUNT(*) FROM patients WHERE id = %(patient_id)s) as patient_exists,
                (SELECT COUNT(*) FROM doctors WHERE id = %(doctor_id)s) as doctor_exists,
                (SELECT COUNT(*) FROM specialties WHERE id = %(specialty_id)s) as specialty_exists
        """
        validate_result = execute_query(validate_query, {
            'patient_id': appointment.patient_id,
            'doctor_id': appointment.doctor_id,
            'specialty_id': appointment.specialty_id
        })
        
        if not validate_result or validate_result[0]['patient_exists'] == 0:
            raise HTTPException(
                status_code=400,
                detail=f"Patient with ID {appointment.patient_id} does not exist"
            )
            
        if validate_result[0]['doctor_exists'] == 0:
            raise HTTPException(
                status_code=400,
                detail=f"Doctor with ID {appointment.doctor_id} does not exist"
            )
            
        if validate_result[0]['specialty_exists'] == 0:
            raise HTTPException(
                status_code=400,
                detail=f"Specialty with ID {appointment.specialty_id} does not exist"
            )
        
        # Check for scheduling conflicts
        conflict_query = """
            SELECT id FROM appointments 
            WHERE doctor_id = %(doctor_id)s
              AND scheduled_date = %(scheduled_date)s
              AND scheduled_time <= %(end_time)s
              AND (scheduled_time + (duration_minutes || ' minutes')::interval) >= %(scheduled_time)s
              AND status NOT IN ('cancelled', 'no-show')
        """
        
        # Calculate end time based on duration
        end_time = (
            datetime.combine(datetime.min, appointment.scheduled_time) + 
            timedelta(minutes=appointment.duration_minutes)
        ).time()
        
        conflict_result = execute_query(conflict_query, {
            'doctor_id': appointment.doctor_id,
            'scheduled_date': appointment.scheduled_date,
            'scheduled_time': appointment.scheduled_time,
            'end_time': end_time
        })
        
        if conflict_result:
            raise HTTPException(
                status_code=400,
                detail="The doctor already has an appointment scheduled at this time"
            )
        
        # Insert new appointment
        query = """
            INSERT INTO appointments (
                patient_id, doctor_id, specialty_id, scheduled_date, scheduled_time,
                duration_minutes, status, notes
            ) VALUES (
                %(patient_id)s, %(doctor_id)s, %(specialty_id)s, %(scheduled_date)s,
                %(scheduled_time)s, %(duration_minutes)s, %(status)s, %(notes)s
            )
            RETURNING id, uuid, patient_id, doctor_id, specialty_id, 
                scheduled_date, scheduled_time, duration_minutes, status, 
                notes, created_at, updated_at
        """
        
        params = appointment.dict()
        result = execute_query(query, params)
        
        return result[0]
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error creating appointment: {str(e)}")
        raise HTTPException(
            status_code=500,
            detail="An error occurred while creating the appointment"
        )

@router.put("/{appointment_id}", response_model=Appointment)
async def update_appointment(
    appointment: AppointmentUpdate,
    appointment_id: int = Path(..., gt=0, description="The ID of the appointment to update"),
):
    """
    Update an existing appointment.
    """
    try:
        # Check if appointment exists
        check_query = "SELECT * FROM appointments WHERE id = %(appointment_id)s"
        check_result = execute_query(check_query, {'appointment_id': appointment_id})
        
        if not check_result:
            raise HTTPException(
                status_code=404,
                detail=f"Appointment with ID {appointment_id} not found"
            )
        
        current_appointment = check_result[0]
        
        # Validate entities if they are being updated
        if appointment.doctor_id or appointment.specialty_id:
            validate_query = """
                SELECT 
                    (SELECT COUNT(*) FROM doctors WHERE id = %(doctor_id)s) as doctor_exists,
                    (SELECT COUNT(*) FROM specialties WHERE id = %(specialty_id)s) as specialty_exists
            """
            
            validate_params = {
                'doctor_id': appointment.doctor_id or current_appointment['doctor_id'],
                'specialty_id': appointment.specialty_id or current_appointment['specialty_id']
            }
            
            validate_result = execute_query(validate_query, validate_params)
            
            if validate_result[0]['doctor_exists'] == 0:
                raise HTTPException(
                    status_code=400,
                    detail=f"Doctor with ID {validate_params['doctor_id']} does not exist"
                )
                
            if validate_result[0]['specialty_exists'] == 0:
                raise HTTPException(
                    status_code=400,
                    detail=f"Specialty with ID {validate_params['specialty_id']} does not exist"
                )
        
        # Check for scheduling conflicts if date/time/doctor is changing
        if (appointment.scheduled_date or appointment.scheduled_time or appointment.doctor_id):
            # Prepare parameters for conflict check
            doctor_id = appointment.doctor_id or current_appointment['doctor_id']
            scheduled_date = appointment.scheduled_date or current_appointment['scheduled_date']
            scheduled_time = appointment.scheduled_time or current_appointment['scheduled_time']
            duration_minutes = appointment.duration_minutes or current_appointment['duration_minutes']
            
            # Calculate end time based on duration
            end_time = (
                datetime.combine(datetime.min, scheduled_time) + 
                timedelta(minutes=duration_minutes)
            ).time()
            
            conflict_query = """
                SELECT id FROM appointments 
                WHERE doctor_id = %(doctor_id)s
                  AND scheduled_date = %(scheduled_date)s
                  AND scheduled_time <= %(end_time)s
                  AND (scheduled_time + (duration_minutes || ' minutes')::interval) >= %(scheduled_time)s
                  AND status NOT IN ('cancelled', 'no-show')
                  AND id != %(appointment_id)s
            """
            
            conflict_result = execute_query(conflict_query, {
                'doctor_id': doctor_id,
                'scheduled_date': scheduled_date,
                'scheduled_time': scheduled_time,
                'end_time': end_time,
                'appointment_id': appointment_id
            })
            
            if conflict_result:
                raise HTTPException(
                    status_code=400,
                    detail="The doctor already has an appointment scheduled at this time"
                )
        
        # Build update query dynamically
        update_fields = []
        params = {'appointment_id': appointment_id}
        
        # Only include non-None fields in the update
        appointment_dict = appointment.dict(exclude_unset=True)
        for key, value in appointment_dict.items():
            if value is not None:
                update_fields.append(f"{key} = %({key})s")
                params[key] = value
        
        if not update_fields:
            # If no fields to update, just return the appointment
            query = """
                SELECT id, uuid, patient_id, doctor_id, specialty_id, 
                    scheduled_date, scheduled_time, duration_minutes, status, 
                    notes, created_at, updated_at
                FROM appointments
                WHERE id = %(appointment_id)s
            """
        else:
            # Build and execute update query
            query = f"""
                UPDATE appointments
                SET {", ".join(update_fields)}
                WHERE id = %(appointment_id)s
                RETURNING id, uuid, patient_id, doctor_id, specialty_id, 
                    scheduled_date, scheduled_time, duration_minutes, status, 
                    notes, created_at, updated_at
            """
        
        result = execute_query(query, params)
        return result[0]
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error updating appointment {appointment_id}: {str(e)}")
        raise HTTPException(
            status_code=500,
            detail="An error occurred while updating the appointment"
        )

@router.delete("/{appointment_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_appointment(
    appointment_id: int = Path(..., gt=0, description="The ID of the appointment to delete"),
):
    """
    Delete an appointment or mark it as cancelled.
    
    If the appointment is in the future, it will be deleted.
    If it has already happened or has associated medical records, it will be marked as cancelled.
    """
    try:
        # Check if appointment exists and if it has related records
        check_query = """
            SELECT a.*, 
                   (SELECT COUNT(*) FROM medical_records WHERE appointment_id = a.id) as has_records,
                   a.scheduled_date < CURRENT_DATE as is_past
            FROM appointments a
            WHERE a.id = %(appointment_id)s
        """
        
        check_result = execute_query(check_query, {'appointment_id': appointment_id})
        
        if not check_result:
            raise HTTPException(
                status_code=404,
                detail=f"Appointment with ID {appointment_id} not found"
            )
        
        appointment = check_result[0]
        
        # If appointment has medical records or is in the past, mark as cancelled
        if appointment['has_records'] > 0 or appointment['is_past']:
            if appointment['status'] == 'cancelled':
                # Already cancelled, no action needed
                return None
                
            update_query = """
                UPDATE appointments
                SET status = 'cancelled'
                WHERE id = %(appointment_id)s
            """
            
            execute_query(update_query, {'appointment_id': appointment_id}, fetch=False)
            return None
        
        # Otherwise, delete the appointment
        delete_query = "DELETE FROM appointments WHERE id = %(appointment_id)s"
        execute_query(delete_query, {'appointment_id': appointment_id}, fetch=False)
        
        return None
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error deleting appointment {appointment_id}: {str(e)}")
        raise HTTPException(
            status_code=500,
            detail="An error occurred while deleting the appointment"
        ) 