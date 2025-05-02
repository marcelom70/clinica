import os
import sys
import pytest
import asyncio
from datetime import datetime
import signal
import subprocess

# Add parent directory to path to import modules
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from src.database.connection import init_db, close_db, execute_query

@pytest.fixture(scope="session")
def event_loop():
    """Create an event loop for the session."""
    loop = asyncio.get_event_loop_policy().new_event_loop()
    yield loop
    loop.close()

@pytest.fixture(scope="session")
async def setup_database():
    """Set up the test database with test data."""
    await init_db()
    
    # Insert test data
    
    # Test doctor
    doctor_query = """
        INSERT INTO doctors (name, specialization, email, phone)
        VALUES ('Test Doctor', 'Test Specialization', 'test.doctor@example.com', '123-456-7890')
        ON CONFLICT (email) DO UPDATE 
        SET name = EXCLUDED.name, specialization = EXCLUDED.specialization, phone = EXCLUDED.phone
        RETURNING id
    """
    doctor_result = await execute_query(doctor_query)
    doctor_id = doctor_result[0]['id']
    
    # Test patient
    patient_query = """
        INSERT INTO patients (name, date_of_birth, gender, email, phone, address, insurance_info)
        VALUES ('Test Patient', '1990-01-01', 'Other', 'test.patient@example.com', '987-654-3210', 
                '123 Test St, Test City', 'Test Insurance Company')
        ON CONFLICT (email) DO UPDATE 
        SET name = EXCLUDED.name, date_of_birth = EXCLUDED.date_of_birth, gender = EXCLUDED.gender,
            phone = EXCLUDED.phone, address = EXCLUDED.address, insurance_info = EXCLUDED.insurance_info
        RETURNING id
    """
    patient_result = await execute_query(patient_query)
    patient_id = patient_result[0]['id']
    
    # Test appointment
    appointment_date = datetime.now()
    appointment_query = """
        INSERT INTO appointments (patient_id, doctor_id, appointment_date, reason, status, notes)
        VALUES (%s, %s, %s, 'Test Appointment', 'scheduled', 'Test appointment notes')
        ON CONFLICT DO NOTHING
        RETURNING id
    """
    appointment_result = await execute_query(
        appointment_query, 
        [patient_id, doctor_id, appointment_date]
    )
    
    if appointment_result:
        appointment_id = appointment_result[0]['id']
        
        # Test medical record
        medical_record_query = """
            INSERT INTO medical_records (
                patient_id, doctor_id, appointment_id, diagnosis, treatment, prescription, notes, record_date
            )
            VALUES (%s, %s, %s, 'Test Diagnosis', 'Test Treatment', 'Test Prescription', 'Test Notes', CURRENT_TIMESTAMP)
            ON CONFLICT DO NOTHING
        """
        await execute_query(
            medical_record_query, 
            [patient_id, doctor_id, appointment_id]
        )
    
    # Return test data IDs
    return {
        'doctor_id': doctor_id,
        'patient_id': patient_id,
        'appointment_id': appointment_result[0]['id'] if appointment_result else None
    }

@pytest.fixture(scope="session")
async def test_ids(setup_database):
    """Return the test data IDs."""
    return setup_database

@pytest.fixture(scope="session", autouse=True)
async def cleanup_database():
    """Cleanup the database after tests."""
    # Setup: init_db is called in setup_database
    yield
    # Cleanup
    await close_db()

# Find PIDs using port 8080
try:
    output = subprocess.check_output(["lsof", "-t", "-i", ":8080"]).decode().strip()
    if output:
        pids = output.split('\n')
        for pid in pids:
            print(f"Killing process {pid}")
            try:
                os.kill(int(pid), signal.SIGKILL)
                print(f"Process {pid} killed")
            except Exception as e:
                print(f"Error killing process {pid}: {e}")
    else:
        print("No processes found using port 8080")
except Exception as e:
    print(f"Error finding processes: {e}")

# Try to free port 8081 as well
try:
    output = subprocess.check_output(["lsof", "-t", "-i", ":8081"]).decode().strip()
    if output:
        pids = output.split('\n')
        for pid in pids:
            print(f"Killing process {pid}")
            try:
                os.kill(int(pid), signal.SIGKILL)
                print(f"Process {pid} killed")
            except Exception as e:
                print(f"Error killing process {pid}: {e}")
except Exception as e:
    print(f"Error finding processes: {e}")

print("Cleanup completed") 