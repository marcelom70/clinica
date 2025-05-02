import os
import asyncio
import logging
import json
import sys
from datetime import datetime

# Add parent directory to path to import modules
sys.path.append(os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))))

from src.database.connection import execute_query, fetch_one, init_db, close_db

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(name)s - %(levelname)s - %(message)s",
)
logger = logging.getLogger(__name__)

async def seed_database():
    """Seed the database with sample data"""
    try:
        # Connect to the database
        await init_db()
        
        # Load seed data
        seed_data_path = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), 
                                     "database", "seed_data.json")
        
        with open(seed_data_path, 'r', encoding='utf-8') as f:
            seed_data = json.load(f)
        
        # Insert doctors
        logger.info("Inserting doctors...")
        for doctor in seed_data.get('doctors', []):
            await execute_query(
                """
                INSERT INTO doctors (name, specialization, email, phone)
                VALUES (%(name)s, %(specialization)s, %(email)s, %(phone)s)
                ON CONFLICT (email) DO NOTHING
                """,
                doctor,
                fetch=False
            )
        
        # Insert patients
        logger.info("Inserting patients...")
        for patient in seed_data.get('patients', []):
            # Convert date string to date object
            if 'date_of_birth' in patient:
                patient['date_of_birth'] = datetime.strptime(patient['date_of_birth'], '%Y-%m-%d').date()
            
            await execute_query(
                """
                INSERT INTO patients (name, date_of_birth, gender, email, phone, address, insurance_info)
                VALUES (%(name)s, %(date_of_birth)s, %(gender)s, %(email)s, %(phone)s, %(address)s, %(insurance_info)s)
                ON CONFLICT (email) DO NOTHING
                """,
                patient,
                fetch=False
            )
        
        # Insert appointments
        logger.info("Inserting appointments...")
        for appointment in seed_data.get('appointments', []):
            # Convert date string to datetime object
            if 'appointment_date' in appointment:
                appointment['appointment_date'] = datetime.fromisoformat(appointment['appointment_date'])
            
            await execute_query(
                """
                INSERT INTO appointments (patient_id, doctor_id, appointment_date, reason, status, notes)
                VALUES (%(patient_id)s, %(doctor_id)s, %(appointment_date)s, %(reason)s, %(status)s, %(notes)s)
                ON CONFLICT (patient_id, doctor_id, appointment_date) DO NOTHING
                RETURNING id
                """,
                appointment
            )
        
        # Insert medical records
        logger.info("Inserting medical records...")
        for record in seed_data.get('medical_records', []):
            await execute_query(
                """
                INSERT INTO medical_records (
                    patient_id, doctor_id, appointment_id, diagnosis, treatment, prescription, notes, record_date
                )
                VALUES (
                    %(patient_id)s, %(doctor_id)s, %(appointment_id)s, %(diagnosis)s, 
                    %(treatment)s, %(prescription)s, %(notes)s, CURRENT_TIMESTAMP
                )
                """,
                record,
                fetch=False
            )
        
        # Close the database connection
        await close_db()
        
        logger.info("Database seeding completed successfully")
    except Exception as e:
        logger.error(f"Error seeding database: {str(e)}")
        raise

if __name__ == "__main__":
    asyncio.run(seed_database()) 