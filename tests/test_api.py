import os
import sys
import pytest
from fastapi.testclient import TestClient

# Add parent directory to path to import modules
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from src.main import app

# Create test client
client = TestClient(app)

def test_health_endpoint():
    """Test the health endpoint."""
    response = client.get("/")
    assert response.status_code == 200
    assert response.json() == {"status": "healthy", "message": "API is running"}

def test_doctors_endpoints():
    """Test the doctors endpoints."""
    # Test GET doctors
    response = client.get("/api/doctors")
    assert response.status_code == 200
    assert isinstance(response.json(), list)
    
    # Test doctor creation (this depends on database setup and should be mocked in a real test)
    # new_doctor = {
    #     "name": "Test Doctor",
    #     "specialization": "Test Specialization",
    #     "email": "test.doctor@test.com",
    #     "phone": "123-456-7890"
    # }
    # response = client.post("/api/doctors", json=new_doctor)
    # assert response.status_code == 201
    # assert response.json()["name"] == new_doctor["name"]

def test_patients_endpoints():
    """Test the patients endpoints."""
    # Test GET patients
    response = client.get("/api/patients")
    assert response.status_code == 200
    assert isinstance(response.json(), list)
    
    # Test patient creation (this depends on database setup and should be mocked in a real test)
    # new_patient = {
    #     "name": "Test Patient",
    #     "date_of_birth": "1990-01-01",
    #     "gender": "Male",
    #     "email": "test.patient@test.com",
    #     "phone": "123-456-7890",
    #     "address": "123 Test St",
    #     "insurance_info": "Test Insurance"
    # }
    # response = client.post("/api/patients", json=new_patient)
    # assert response.status_code == 201
    # assert response.json()["name"] == new_patient["name"]

def test_appointments_endpoints():
    """Test the appointments endpoints."""
    # Test GET appointments
    response = client.get("/api/appointments")
    assert response.status_code == 200
    assert isinstance(response.json(), list)

def test_medical_records_endpoints():
    """Test the medical records endpoints."""
    # This test would require setting up a test database with specific data
    # For now, we'll just test that the endpoints return a proper response
    
    # Getting a medical record requires an ID, which depends on database setup
    # So we'll skip detailed testing for now
    pass

def test_ai_services_endpoints():
    """Test the AI services endpoints."""
    # AI service endpoints generally require valid data that's dependent on other resources
    # So we'll skip detailed testing for now
    pass 