from fastapi import APIRouter, HTTPException, UploadFile, File, Form, Query, Path, Depends, status, BackgroundTasks
from typing import List, Optional, Dict, Any
import logging
import sys
import os
import tempfile
import json
import shutil
from pathlib import Path as FilePath
from datetime import date, datetime, time, timedelta

# Add parent directory to path
sys.path.append(os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))))

# Import services and database functions
from database.connection import execute_query
from ai_integration.ocr_processor import OCRProcessor
from ai_integration.data_importer import DataImporter

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

# Create router
router = APIRouter(
    tags=["ai_services"],
    responses={400: {"description": "Bad Request"}, 500: {"description": "Internal Server Error"}},
)

# Initialize services
ocr_processor = OCRProcessor()
data_importer = DataImporter()

# Create upload directory if it doesn't exist
UPLOAD_DIR = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))), "uploads")
os.makedirs(UPLOAD_DIR, exist_ok=True)

def process_document_task(file_path: str, document_type: str, delete_after: bool = False):
    """Background task to process a document"""
    try:
        logger.info(f"Processing document in background: {file_path}")
        result = data_importer.import_document(file_path, document_type)
        logger.info(f"Document processed successfully: {result}")
        
        if delete_after and os.path.exists(file_path):
            os.remove(file_path)
            logger.info(f"Deleted temporary file: {file_path}")
    except Exception as e:
        logger.error(f"Error processing document: {str(e)}")
        if delete_after and os.path.exists(file_path):
            os.remove(file_path)
            logger.info(f"Deleted temporary file after error: {file_path}")

@router.post("/process-document", status_code=status.HTTP_202_ACCEPTED)
async def process_document(
    background_tasks: BackgroundTasks,
    file: UploadFile = File(...),
    document_type: str = Form("patient_record"),
):
    """
    Upload and process a document with OCR and AI.
    
    The document will be processed asynchronously in a background task.
    """
    try:
        # Save the uploaded file to a temporary location
        file_path = os.path.join(UPLOAD_DIR, f"{datetime.now().strftime('%Y%m%d%H%M%S')}_{file.filename}")
        
        with open(file_path, "wb") as buffer:
            shutil.copyfileobj(file.file, buffer)
        
        # Add the processing task to the background
        background_tasks.add_task(process_document_task, file_path, document_type, True)
        
        return {
            "message": "Document uploaded and queued for processing",
            "document_type": document_type,
            "filename": file.filename
        }
    except Exception as e:
        logger.error(f"Error uploading document: {str(e)}")
        raise HTTPException(
            status_code=500,
            detail="An error occurred while uploading the document"
        )

@router.post("/process-document-sync", status_code=status.HTTP_200_OK)
async def process_document_sync(
    file: UploadFile = File(...),
    document_type: str = Form("patient_record"),
):
    """
    Upload and process a document with OCR and AI synchronously.
    
    This endpoint will process the document immediately and return the results.
    It may take longer to respond but provides immediate feedback.
    """
    temp_file = None
    try:
        # Save the uploaded file to a temporary location
        with tempfile.NamedTemporaryFile(delete=False) as tmp:
            temp_file = tmp.name
            shutil.copyfileobj(file.file, tmp)
        
        # Process the document
        ocr_result = ocr_processor.process_document(temp_file, document_type)
        
        # Extract structured data
        patient_data, appointment_data, medical_record_data = ocr_processor.extract_structured_data(ocr_result)
        
        # Generate AI summary if medical record data is available
        ai_summary = None
        if medical_record_data:
            ai_summary = ocr_processor.generate_ai_summary(medical_record_data)
        
        return {
            "confidence": ocr_result.get('confidence', 0),
            "patient_data": patient_data,
            "appointment_data": appointment_data,
            "medical_record_data": medical_record_data,
            "ai_summary": ai_summary
        }
    except Exception as e:
        logger.error(f"Error processing document: {str(e)}")
        raise HTTPException(
            status_code=500,
            detail="An error occurred while processing the document"
        )
    finally:
        # Clean up the temporary file
        if temp_file and os.path.exists(temp_file):
            os.remove(temp_file)

@router.get("/processing-status")
async def get_processing_status():
    """
    Get the status of document processing jobs.
    """
    try:
        query = """
            SELECT processing_status, COUNT(*) as count
            FROM digitized_documents
            GROUP BY processing_status
        """
        
        result = execute_query(query)
        
        # Organize results into a status summary
        status_summary = {
            "total": 0,
            "pending": 0,
            "processing": 0,
            "completed": 0,
            "failed": 0
        }
        
        for item in result:
            status = item.get('processing_status', 'unknown')
            count = item.get('count', 0)
            
            status_summary['total'] += count
            if status in status_summary:
                status_summary[status] = count
        
        return status_summary
    except Exception as e:
        logger.error(f"Error fetching processing status: {str(e)}")
        raise HTTPException(
            status_code=500,
            detail="An error occurred while fetching processing status"
        )

@router.get("/patient-insights/{patient_id}")
async def get_patient_insights(
    patient_id: int = Path(..., gt=0, description="The ID of the patient to get insights for"),
):
    """
    Get AI-generated insights about a patient's medical history.
    """
    try:
        # Get patient details and medical records
        query = """
            SELECT p.id, p.name, p.date_of_birth, p.gender,
                   (SELECT COUNT(*) FROM appointments a WHERE a.patient_id = p.id) as appointment_count,
                   (SELECT COUNT(*) FROM medical_records mr WHERE mr.patient_id = p.id) as record_count
            FROM patients p
            WHERE p.id = %(patient_id)s
        """
        
        patient_result = execute_query(query, {'patient_id': patient_id})
        
        if not patient_result:
            raise HTTPException(
                status_code=404,
                detail=f"Patient with ID {patient_id} not found"
            )
            
        patient = patient_result[0]
        
        # Get medical records with AI summaries
        records_query = """
            SELECT mr.id, mr.consultation_date, mr.symptoms, mr.diagnosis, 
                   mr.treatment, mr.follow_up, mr.ai_summary,
                   d.name as doctor_name, s.name as specialty_name
            FROM medical_records mr
            JOIN doctors d ON mr.doctor_id = d.id
            JOIN doctor_specialties ds ON d.id = ds.doctor_id
            JOIN specialties s ON ds.specialty_id = s.id
            WHERE mr.patient_id = %(patient_id)s
            ORDER BY mr.consultation_date DESC
        """
        
        records = execute_query(records_query, {'patient_id': patient_id})
        
        # Generate a combined insight from all records
        # (In a real implementation, this would use a more sophisticated AI model)
        patient_age = None
        if patient.get('date_of_birth'):
            today = date.today()
            dob = patient.get('date_of_birth')
            patient_age = today.year - dob.year - ((today.month, today.day) < (dob.month, dob.day))
        
        # Get most recent diagnoses (up to 3)
        recent_diagnoses = [r.get('diagnosis') for r in records[:3] if r.get('diagnosis')]
        
        # Generate insights based on available data
        insights = []
        
        if patient_age:
            insights.append(f"Paciente tem {patient_age} anos de idade.")
            
        if recent_diagnoses:
            insights.append(f"Diagnósticos recentes incluem: {', '.join(recent_diagnoses)}.")
            
        if patient.get('appointment_count', 0) > 0:
            insights.append(f"Total de {patient.get('appointment_count')} consultas registradas.")
            
        if len(records) > 0:
            # Look for patterns in symptoms and diagnoses
            all_symptoms = [r.get('symptoms') for r in records if r.get('symptoms')]
            all_diagnoses = [r.get('diagnosis') for r in records if r.get('diagnosis')]
            
            # Count specialties
            specialties = {}
            for r in records:
                specialty = r.get('specialty_name')
                if specialty:
                    specialties[specialty] = specialties.get(specialty, 0) + 1
                    
            if specialties:
                most_common_specialty = max(specialties.items(), key=lambda x: x[1])[0]
                insights.append(f"Especialidade mais consultada: {most_common_specialty}.")
            
            # Check for recurring issues (simplified approach)
            if len(all_symptoms) > 2:
                insights.append("Análise sugere acompanhamento contínuo de condições recorrentes.")
                
        # Add placeholder insight
        if not insights:
            insights.append("Não há dados suficientes para gerar insights detalhados.")
        
        return {
            "patient_id": patient_id,
            "patient_name": patient.get('name'),
            "record_count": len(records),
            "insights": insights,
            "latest_records": records[:3] if records else []
        }
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error generating patient insights for {patient_id}: {str(e)}")
        raise HTTPException(
            status_code=500,
            detail="An error occurred while generating patient insights"
        )

@router.get("/appointment-suggestions/{patient_id}")
async def get_appointment_suggestions(
    patient_id: int = Path(..., gt=0, description="The ID of the patient to get suggestions for"),
):
    """
    Get AI-generated suggestions for upcoming appointments based on patient history.
    """
    try:
        # Get patient details and medical records
        patient_query = """
            SELECT p.id, p.name, p.date_of_birth, p.gender
            FROM patients p
            WHERE p.id = %(patient_id)s
        """
        
        patient_result = execute_query(patient_query, {'patient_id': patient_id})
        
        if not patient_result:
            raise HTTPException(
                status_code=404,
                detail=f"Patient with ID {patient_id} not found"
            )
            
        # Get latest medical record with follow-up information
        records_query = """
            SELECT mr.id, mr.consultation_date, mr.diagnosis, mr.follow_up,
                   d.id as doctor_id, d.name as doctor_name, 
                   s.id as specialty_id, s.name as specialty_name
            FROM medical_records mr
            JOIN doctors d ON mr.doctor_id = d.id
            JOIN appointments a ON mr.appointment_id = a.id
            JOIN specialties s ON a.specialty_id = s.id
            WHERE mr.patient_id = %(patient_id)s AND mr.follow_up IS NOT NULL
            ORDER BY mr.consultation_date DESC
            LIMIT 1
        """
        
        record_result = execute_query(records_query, {'patient_id': patient_id})
        
        # Get past appointments to identify patterns
        appointments_query = """
            SELECT a.specialty_id, s.name as specialty_name, COUNT(*) as visit_count
            FROM appointments a
            JOIN specialties s ON a.specialty_id = s.id
            WHERE a.patient_id = %(patient_id)s
            GROUP BY a.specialty_id, s.name
            ORDER BY visit_count DESC
            LIMIT 3
        """
        
        specialty_result = execute_query(appointments_query, {'patient_id': patient_id})
        
        # Generate suggestions based on available data
        suggestions = []
        
        # Check if there's follow-up information in the latest record
        if record_result:
            latest_record = record_result[0]
            
            if latest_record.get('follow_up'):
                suggestions.append({
                    "reason": "Acompanhamento recomendado",
                    "details": latest_record.get('follow_up'),
                    "doctor_id": latest_record.get('doctor_id'),
                    "doctor_name": latest_record.get('doctor_name'),
                    "specialty_id": latest_record.get('specialty_id'),
                    "specialty_name": latest_record.get('specialty_name')
                })
        
        # Suggest appointments based on frequently visited specialties
        if specialty_result:
            for specialty in specialty_result:
                if not any(s.get('specialty_id') == specialty.get('specialty_id') for s in suggestions):
                    suggestions.append({
                        "reason": "Baseado em histórico de consultas",
                        "details": f"Consulta de rotina com especialidade frequentemente visitada",
                        "specialty_id": specialty.get('specialty_id'),
                        "specialty_name": specialty.get('specialty_name')
                    })
        
        # If no suggestions yet, add a general check-up suggestion
        if not suggestions:
            suggestions.append({
                "reason": "Check-up geral recomendado",
                "details": "Consulta de rotina para avaliação de saúde"
            })
        
        return {
            "patient_id": patient_id,
            "patient_name": patient_result[0].get('name'),
            "suggestions": suggestions
        }
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error generating appointment suggestions for {patient_id}: {str(e)}")
        raise HTTPException(
            status_code=500,
            detail="An error occurred while generating appointment suggestions"
        ) 