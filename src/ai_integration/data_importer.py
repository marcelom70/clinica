import os
import logging
import json
from typing import Dict, List, Optional, Any
import sys
from datetime import datetime

# Add the parent directory to the path to import modules
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from database.connection import execute_query, execute_batch
from ai_integration.ocr_processor import OCRProcessor

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

class DataImporter:
    """Handles importing digitized medical records into the database"""
    
    def __init__(self):
        self.ocr_processor = OCRProcessor()
    
    def process_directory(self, directory_path: str) -> Dict[str, int]:
        """
        Process all document files in a directory
        
        Args:
            directory_path: Path to directory containing documents
            
        Returns:
            Statistics about processed files
        """
        if not os.path.exists(directory_path):
            raise FileNotFoundError(f"Directory not found: {directory_path}")
            
        logger.info(f"Processing documents in directory: {directory_path}")
        
        stats = {
            'total_files': 0,
            'processed_files': 0,
            'failed_files': 0,
            'patients_added': 0,
            'records_added': 0
        }
        
        for root, _, files in os.walk(directory_path):
            for file in files:
                if file.lower().endswith(('.jpg', '.jpeg', '.png', '.pdf', '.tiff')):
                    file_path = os.path.join(root, file)
                    stats['total_files'] += 1
                    
                    try:
                        # Determine document type from file name or folder structure
                        document_type = self._infer_document_type(file_path)
                        
                        # Process and import the document
                        result = self.import_document(file_path, document_type)
                        
                        if result.get('patient_id'):
                            stats['patients_added'] += 1
                        if result.get('record_id'):
                            stats['records_added'] += 1
                            
                        stats['processed_files'] += 1
                        logger.info(f"Successfully processed: {file_path}")
                        
                        # Update document status in database
                        self._update_document_status(file_path, 'completed', result)
                        
                    except Exception as e:
                        stats['failed_files'] += 1
                        logger.error(f"Failed to process {file_path}: {str(e)}")
                        self._update_document_status(file_path, 'failed', {'error': str(e)})
        
        logger.info(f"Directory processing complete. Stats: {stats}")
        return stats
    
    def import_document(self, file_path: str, document_type: str = 'patient_record') -> Dict[str, Any]:
        """
        Process a single document and import its data into the database
        
        Args:
            file_path: Path to the document file
            document_type: Type of document (patient_record, prescription, etc.)
            
        Returns:
            Dictionary with imported entity IDs
        """
        # First, record the document in the database
        document_id = self._register_document(file_path, document_type)
        
        # Process the document with OCR
        ocr_result = self.ocr_processor.process_document(file_path, document_type)
        
        # Extract structured data
        patient_data, appointment_data, medical_record_data = self.ocr_processor.extract_structured_data(ocr_result)
        
        result = {
            'document_id': document_id,
            'confidence': ocr_result.get('confidence', 0)
        }
        
        # Import patient data if available
        if patient_data:
            patient_id = self._import_patient(patient_data)
            result['patient_id'] = patient_id
            
            # Update the document with patient_id
            self._update_document_patient(document_id, patient_id)
        
        # Import appointment and medical record if available
        if appointment_data and medical_record_data and 'patient_id' in result:
            # Generate AI summary
            ai_summary = self.ocr_processor.generate_ai_summary(medical_record_data)
            medical_record_data['ai_summary'] = ai_summary
            
            # Find or create doctor
            doctor_id = self._find_or_create_doctor(appointment_data.get('doctor_name', ''))
            
            # Find or create specialty
            specialty_id = self._find_or_create_specialty(appointment_data.get('specialty', ''))
            
            # Create or update appointment
            appointment_id = self._import_appointment(
                result['patient_id'], 
                doctor_id,
                specialty_id,
                appointment_data
            )
            result['appointment_id'] = appointment_id
            
            # Create medical record
            record_id = self._import_medical_record(
                result['patient_id'],
                doctor_id,
                appointment_id,
                medical_record_data,
                document_id
            )
            result['record_id'] = record_id
        
        return result
    
    def _register_document(self, file_path: str, document_type: str) -> int:
        """Register document in the database before processing"""
        query = """
            INSERT INTO digitized_documents 
            (document_type, file_path, processed, processing_status)
            VALUES (%(document_type)s, %(file_path)s, FALSE, 'pending')
            RETURNING id
        """
        params = {
            'document_type': document_type,
            'file_path': file_path
        }
        
        result = execute_query(query, params)
        return result[0]['id'] if result else None
    
    def _update_document_status(self, file_path: str, status: str, processing_notes: Dict[str, Any]) -> None:
        """Update document status after processing"""
        query = """
            UPDATE digitized_documents
            SET processing_status = %(status)s,
                processed = %(processed)s,
                processing_notes = %(notes)s,
                ocr_confidence = %(confidence)s,
                updated_at = CURRENT_TIMESTAMP
            WHERE file_path = %(file_path)s
        """
        params = {
            'status': status,
            'processed': status == 'completed',
            'notes': json.dumps(processing_notes),
            'confidence': processing_notes.get('confidence', 0),
            'file_path': file_path
        }
        
        execute_query(query, params, fetch=False)
    
    def _update_document_patient(self, document_id: int, patient_id: int) -> None:
        """Update document with patient ID"""
        query = """
            UPDATE digitized_documents
            SET patient_id = %(patient_id)s,
                updated_at = CURRENT_TIMESTAMP
            WHERE id = %(document_id)s
        """
        params = {
            'patient_id': patient_id,
            'document_id': document_id
        }
        
        execute_query(query, params, fetch=False)
    
    def _import_patient(self, patient_data: Dict[str, Any]) -> int:
        """Import patient data, updating if patient exists"""
        # Check if patient exists by CPF
        if patient_data.get('cpf'):
            query = "SELECT id FROM patients WHERE cpf = %(cpf)s"
            result = execute_query(query, {'cpf': patient_data.get('cpf')})
            
            if result:
                # Patient exists, update information
                patient_id = result[0]['id']
                self._update_patient(patient_id, patient_data)
                return patient_id
        
        # Patient doesn't exist or no CPF, create new patient
        query = """
            INSERT INTO patients
            (name, cpf, date_of_birth, gender, phone, email, insurance_number)
            VALUES (
                %(name)s, %(cpf)s, %(date_of_birth)s, %(gender)s, 
                %(phone)s, %(email)s, %(insurance_number)s
            )
            RETURNING id
        """
        params = {
            'name': patient_data.get('name'),
            'cpf': patient_data.get('cpf'),
            'date_of_birth': patient_data.get('date_of_birth'),
            'gender': patient_data.get('gender'),
            'phone': patient_data.get('phone'),
            'email': patient_data.get('email'),
            'insurance_number': patient_data.get('insurance_number')
        }
        
        result = execute_query(query, params)
        return result[0]['id'] if result else None
    
    def _update_patient(self, patient_id: int, patient_data: Dict[str, Any]) -> None:
        """Update existing patient data"""
        query = """
            UPDATE patients
            SET 
                name = COALESCE(%(name)s, name),
                date_of_birth = COALESCE(%(date_of_birth)s, date_of_birth),
                gender = COALESCE(%(gender)s, gender),
                phone = COALESCE(%(phone)s, phone),
                email = COALESCE(%(email)s, email),
                insurance_number = COALESCE(%(insurance_number)s, insurance_number),
                updated_at = CURRENT_TIMESTAMP
            WHERE id = %(patient_id)s
        """
        params = {
            'patient_id': patient_id,
            'name': patient_data.get('name'),
            'date_of_birth': patient_data.get('date_of_birth'),
            'gender': patient_data.get('gender'),
            'phone': patient_data.get('phone'),
            'email': patient_data.get('email'),
            'insurance_number': patient_data.get('insurance_number')
        }
        
        execute_query(query, params, fetch=False)
    
    def _find_or_create_doctor(self, doctor_name: str) -> int:
        """Find doctor by name or create if not exists"""
        if not doctor_name:
            return None
            
        # Look for doctor
        query = "SELECT id FROM doctors WHERE name = %(name)s"
        result = execute_query(query, {'name': doctor_name})
        
        if result:
            return result[0]['id']
            
        # Create doctor if not found
        query = """
            INSERT INTO doctors (name, crm)
            VALUES (%(name)s, %(crm)s)
            RETURNING id
        """
        params = {
            'name': doctor_name,
            'crm': 'CRM-PENDENTE'  # Placeholder, would need to be updated later
        }
        
        result = execute_query(query, params)
        return result[0]['id'] if result else None
    
    def _find_or_create_specialty(self, specialty_name: str) -> int:
        """Find specialty by name or create if not exists"""
        if not specialty_name:
            return None
            
        # Look for specialty
        query = "SELECT id FROM specialties WHERE name = %(name)s"
        result = execute_query(query, {'name': specialty_name})
        
        if result:
            return result[0]['id']
            
        # Create specialty if not found
        query = """
            INSERT INTO specialties (name)
            VALUES (%(name)s)
            RETURNING id
        """
        params = {
            'name': specialty_name
        }
        
        result = execute_query(query, params)
        return result[0]['id'] if result else None
    
    def _import_appointment(self, patient_id: int, doctor_id: int, specialty_id: int, appointment_data: Dict[str, Any]) -> int:
        """Import appointment data"""
        query = """
            INSERT INTO appointments
            (patient_id, doctor_id, specialty_id, scheduled_date, scheduled_time, status)
            VALUES (
                %(patient_id)s, %(doctor_id)s, %(specialty_id)s, 
                %(scheduled_date)s, %(scheduled_time)s, 'completed'
            )
            RETURNING id
        """
        
        # Parse date and time if provided as a single field
        scheduled_date = appointment_data.get('scheduled_date')
        scheduled_time = '12:00:00'  # Default if not specified
        
        params = {
            'patient_id': patient_id,
            'doctor_id': doctor_id,
            'specialty_id': specialty_id,
            'scheduled_date': scheduled_date,
            'scheduled_time': scheduled_time
        }
        
        result = execute_query(query, params)
        return result[0]['id'] if result else None
    
    def _import_medical_record(self, patient_id: int, doctor_id: int, appointment_id: int, 
                              medical_record_data: Dict[str, Any], document_id: int) -> int:
        """Import medical record data"""
        query = """
            INSERT INTO medical_records
            (patient_id, doctor_id, appointment_id, consultation_date,
             symptoms, diagnosis, treatment, follow_up, notes,
             digitized_from_physical, source_document_reference, ai_summary)
            VALUES (
                %(patient_id)s, %(doctor_id)s, %(appointment_id)s, %(consultation_date)s,
                %(symptoms)s, %(diagnosis)s, %(treatment)s, %(follow_up)s, %(notes)s,
                TRUE, %(source_document)s, %(ai_summary)s
            )
            RETURNING id
        """
        
        params = {
            'patient_id': patient_id,
            'doctor_id': doctor_id,
            'appointment_id': appointment_id,
            'consultation_date': medical_record_data.get('consultation_date'),
            'symptoms': medical_record_data.get('symptoms'),
            'diagnosis': medical_record_data.get('diagnosis'),
            'treatment': medical_record_data.get('treatment'),
            'follow_up': medical_record_data.get('follow_up'),
            'notes': medical_record_data.get('notes'),
            'source_document': f"document_id:{document_id}",
            'ai_summary': medical_record_data.get('ai_summary')
        }
        
        result = execute_query(query, params)
        return result[0]['id'] if result else None
    
    def _infer_document_type(self, file_path: str) -> str:
        """Infer document type from file path or name"""
        file_name = os.path.basename(file_path).lower()
        
        if 'prontuario' in file_name or 'ficha' in file_name:
            return 'patient_record'
        elif 'receita' in file_name or 'prescricao' in file_name:
            return 'prescription'
        elif 'exame' in file_name:
            return 'exam'
        else:
            return 'unknown'


def main():
    """Main function to run the data importer"""
    import argparse
    
    parser = argparse.ArgumentParser(description='Import digitized medical documents into the database')
    parser.add_argument('directory', help='Directory containing medical documents to process')
    parser.add_argument('--type', help='Document type (patient_record, prescription, etc.)', default=None)
    
    args = parser.parse_args()
    
    importer = DataImporter()
    stats = importer.process_directory(args.directory)
    
    print("Import completed:")
    print(f"Total files: {stats['total_files']}")
    print(f"Processed successfully: {stats['processed_files']}")
    print(f"Failed: {stats['failed_files']}")
    print(f"Patients added/updated: {stats['patients_added']}")
    print(f"Medical records added: {stats['records_added']}")


if __name__ == "__main__":
    main() 