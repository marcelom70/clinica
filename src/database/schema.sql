-- Database Schema for Medical Clinic System

-- Drop tables if they exist (for clean setup)
DROP TABLE IF EXISTS medical_records CASCADE;
DROP TABLE IF EXISTS appointments CASCADE;
DROP TABLE IF EXISTS patients CASCADE;
DROP TABLE IF EXISTS doctors CASCADE;
DROP TABLE IF EXISTS doctor_specialties CASCADE;
DROP TABLE IF EXISTS specialties CASCADE;
DROP TABLE IF EXISTS health_insurance_plans CASCADE;
DROP TABLE IF EXISTS digitized_documents CASCADE;
DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS ai_analysis_requests CASCADE;

-- Create extension for UUID generation
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create schema if it doesn't exist
CREATE SCHEMA IF NOT EXISTS public;

-- Health Insurance Plans
CREATE TABLE health_insurance_plans (
    id SERIAL PRIMARY KEY,
    uuid UUID DEFAULT uuid_generate_v4() NOT NULL,
    name VARCHAR(100) NOT NULL,
    code VARCHAR(20) UNIQUE NOT NULL,
    contact_info TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Users table for authentication
CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    role VARCHAR(20) NOT NULL CHECK (role IN ('admin', 'doctor', 'patient', 'staff')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Create doctors table
CREATE TABLE IF NOT EXISTS doctors (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    specialization VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Create patients table
CREATE TABLE IF NOT EXISTS patients (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    date_of_birth DATE NOT NULL,
    gender VARCHAR(10) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20) NOT NULL,
    address TEXT,
    insurance_info TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Create appointments table
CREATE TABLE IF NOT EXISTS appointments (
    id SERIAL PRIMARY KEY,
    patient_id INTEGER NOT NULL REFERENCES patients(id) ON DELETE CASCADE,
    doctor_id INTEGER NOT NULL REFERENCES doctors(id) ON DELETE CASCADE,
    appointment_date TIMESTAMP WITH TIME ZONE NOT NULL,
    reason TEXT NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'scheduled',
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(patient_id, doctor_id, appointment_date)
);

-- Create medical_records table
CREATE TABLE IF NOT EXISTS medical_records (
    id SERIAL PRIMARY KEY,
    patient_id INTEGER NOT NULL REFERENCES patients(id) ON DELETE CASCADE,
    doctor_id INTEGER NOT NULL REFERENCES doctors(id) ON DELETE CASCADE,
    appointment_id INTEGER REFERENCES appointments(id) ON DELETE SET NULL,
    diagnosis TEXT NOT NULL,
    treatment TEXT NOT NULL,
    prescription TEXT,
    notes TEXT,
    record_date TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- AI analysis requests
CREATE TABLE IF NOT EXISTS ai_analysis_requests (
    id SERIAL PRIMARY KEY,
    patient_id INTEGER NOT NULL REFERENCES patients(id) ON DELETE CASCADE,
    medical_record_id INTEGER REFERENCES medical_records(id) ON DELETE CASCADE,
    request_type VARCHAR(50) NOT NULL,
    input_data TEXT NOT NULL,
    results TEXT,
    status VARCHAR(20) DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Digitized Documents
CREATE TABLE digitized_documents (
    id SERIAL PRIMARY KEY,
    uuid UUID DEFAULT uuid_generate_v4() NOT NULL,
    patient_id INTEGER REFERENCES patients(id) ON DELETE CASCADE,
    original_filename VARCHAR(255) NOT NULL,
    storage_path TEXT NOT NULL,
    document_type VARCHAR(50) NOT NULL,
    processing_status VARCHAR(20) DEFAULT 'pending',
    ocr_data JSONB,
    processed_data JSONB,
    medical_record_id INTEGER REFERENCES medical_records(id) ON DELETE SET NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_appointments_patient_id ON appointments(patient_id);
CREATE INDEX IF NOT EXISTS idx_appointments_doctor_id ON appointments(doctor_id);
CREATE INDEX IF NOT EXISTS idx_appointments_date ON appointments(appointment_date);
CREATE INDEX IF NOT EXISTS idx_medical_records_patient_id ON medical_records(patient_id);
CREATE INDEX IF NOT EXISTS idx_medical_records_doctor_id ON medical_records(doctor_id);

-- Add trigger functions for updated_at timestamps
CREATE OR REPLACE FUNCTION update_modified_column()
RETURNS TRIGGER AS $$
BEGIN
   NEW.updated_at = CURRENT_TIMESTAMP;
   RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create triggers for all tables to update timestamps
CREATE TRIGGER update_doctors_timestamp BEFORE UPDATE ON doctors
FOR EACH ROW EXECUTE FUNCTION update_modified_column();

CREATE TRIGGER update_patients_timestamp BEFORE UPDATE ON patients
FOR EACH ROW EXECUTE FUNCTION update_modified_column();

CREATE TRIGGER update_appointments_timestamp BEFORE UPDATE ON appointments
FOR EACH ROW EXECUTE FUNCTION update_modified_column();

CREATE TRIGGER update_medical_records_timestamp BEFORE UPDATE ON medical_records
FOR EACH ROW EXECUTE FUNCTION update_modified_column();

CREATE TRIGGER update_health_insurance_plans_timestamp BEFORE UPDATE ON health_insurance_plans FOR EACH ROW EXECUTE FUNCTION update_modified_column();
CREATE TRIGGER update_digitized_documents_timestamp BEFORE UPDATE ON digitized_documents FOR EACH ROW EXECUTE FUNCTION update_modified_column();

-- Sample data (optional - uncomment to populate with initial data)
/*
-- Insert sample doctors
INSERT INTO doctors (name, specialization, email, phone) VALUES
('Dr. John Smith', 'Cardiology', 'john.smith@clinic.com', '555-1234'),
('Dr. Sarah Johnson', 'Pediatrics', 'sarah.johnson@clinic.com', '555-2345'),
('Dr. Michael Chen', 'Neurology', 'michael.chen@clinic.com', '555-3456');

-- Insert sample patients
INSERT INTO patients (name, email, phone, date_of_birth, address, insurance_number) VALUES
('Alice Brown', 'alice.brown@email.com', '555-4567', '1985-04-12', '123 Main St, Anytown', 'INS-12345'),
('Bob Wilson', 'bob.wilson@email.com', '555-5678', '1972-09-23', '456 Oak Dr, Somecity', 'INS-23456'),
('Carol Davis', 'carol.davis@email.com', '555-6789', '1990-07-15', '789 Pine Ave, Othertown', 'INS-34567');
*/

-- Data seeding (optional)
-- To populate the database with sample data:
-- python src/utils/seed_db.py