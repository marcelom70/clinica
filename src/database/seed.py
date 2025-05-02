import os
import sys
import logging
from datetime import date, datetime, timedelta
import random

# Add the parent directory to the path to import modules
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from database.connection import execute_query, execute_batch

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

def seed_specialties():
    """Seed medical specialties"""
    specialties = [
        {'name': 'Cardiologia', 'description': 'Especialidade médica que trata das doenças do coração e do sistema circulatório'},
        {'name': 'Dermatologia', 'description': 'Especialidade médica que trata das doenças da pele'},
        {'name': 'Ginecologia', 'description': 'Especialidade médica que trata da saúde do sistema reprodutor feminino'},
        {'name': 'Ortopedia', 'description': 'Especialidade médica que trata das doenças e lesões do sistema músculo-esquelético'},
        {'name': 'Pediatria', 'description': 'Especialidade médica que trata da saúde de crianças e adolescentes'},
        {'name': 'Neurologia', 'description': 'Especialidade médica que trata das doenças do sistema nervoso'},
        {'name': 'Oftalmologia', 'description': 'Especialidade médica que trata das doenças dos olhos'},
        {'name': 'Psiquiatria', 'description': 'Especialidade médica que trata dos transtornos mentais'}
    ]
    
    query = """
        INSERT INTO specialties (name, description)
        VALUES (%(name)s, %(description)s)
        ON CONFLICT (name) DO NOTHING
    """
    
    execute_batch(query, specialties)
    logger.info(f"Seeded {len(specialties)} specialties")

def seed_insurance_plans():
    """Seed health insurance plans"""
    plans = [
        {'name': 'Unimed', 'code': 'UNI', 'contact_info': 'SAC: 0800 123 456'},
        {'name': 'Amil', 'code': 'AMI', 'contact_info': 'SAC: 0800 789 123'},
        {'name': 'SulAmérica', 'code': 'SUL', 'contact_info': 'SAC: 0800 456 789'},
        {'name': 'Bradesco Saúde', 'code': 'BRA', 'contact_info': 'SAC: 0800 987 654'},
        {'name': 'NotreDame Intermédica', 'code': 'NDI', 'contact_info': 'SAC: 0800 321 654'}
    ]
    
    query = """
        INSERT INTO health_insurance_plans (name, code, contact_info)
        VALUES (%(name)s, %(code)s, %(contact_info)s)
        ON CONFLICT (code) DO NOTHING
    """
    
    execute_batch(query, plans)
    logger.info(f"Seeded {len(plans)} health insurance plans")

def seed_doctors():
    """Seed doctors"""
    doctors = [
        {'name': 'Dr. Carlos Oliveira', 'crm': 'CRM-SP 54321', 'phone': '(11) 99876-5432', 'email': 'carlos.oliveira@clinica.com.br'},
        {'name': 'Dra. Ana Beatriz Mendes', 'crm': 'CRM-SP 65432', 'phone': '(11) 99765-4321', 'email': 'ana.mendes@clinica.com.br'},
        {'name': 'Dr. Roberto Santos', 'crm': 'CRM-SP 76543', 'phone': '(11) 99654-3210', 'email': 'roberto.santos@clinica.com.br'},
        {'name': 'Dra. Juliana Costa', 'crm': 'CRM-SP 87654', 'phone': '(11) 99543-2109', 'email': 'juliana.costa@clinica.com.br'},
        {'name': 'Dr. Marcelo Lima', 'crm': 'CRM-SP 98765', 'phone': '(11) 99432-1098', 'email': 'marcelo.lima@clinica.com.br'}
    ]
    
    query = """
        INSERT INTO doctors (name, crm, phone, email)
        VALUES (%(name)s, %(crm)s, %(phone)s, %(email)s)
        ON CONFLICT (crm) DO NOTHING
        RETURNING id
    """
    
    doctor_ids = []
    for doctor in doctors:
        result = execute_query(query, doctor)
        if result:
            doctor_ids.append(result[0]['id'])
    
    logger.info(f"Seeded {len(doctor_ids)} doctors")
    
    # Assign specialties to doctors
    assign_specialties(doctor_ids)

def assign_specialties(doctor_ids):
    """Assign specialties to doctors"""
    if not doctor_ids:
        return
    
    # Get specialty IDs
    specialty_query = "SELECT id FROM specialties"
    specialty_result = execute_query(specialty_query)
    specialty_ids = [s['id'] for s in specialty_result]
    
    if not specialty_ids:
        return
    
    assignments = []
    for doctor_id in doctor_ids:
        # Assign 1-3 specialties to each doctor
        num_specialties = random.randint(1, 3)
        selected_specialties = random.sample(specialty_ids, min(num_specialties, len(specialty_ids)))
        
        for specialty_id in selected_specialties:
            assignments.append({
                'doctor_id': doctor_id,
                'specialty_id': specialty_id
            })
    
    query = """
        INSERT INTO doctor_specialties (doctor_id, specialty_id)
        VALUES (%(doctor_id)s, %(specialty_id)s)
        ON CONFLICT (doctor_id, specialty_id) DO NOTHING
    """
    
    execute_batch(query, assignments)
    logger.info(f"Assigned {len(assignments)} specialties to doctors")

def seed_patients():
    """Seed patients"""
    today = date.today()
    
    patients = [
        {
            'name': 'Maria Silva Santos',
            'cpf': '123.456.789-00',
            'date_of_birth': date(1985, 6, 15),
            'gender': 'Feminino',
            'phone': '(11) 98765-4321',
            'email': 'maria.silva@email.com',
            'address': 'Rua das Flores, 123, São Paulo - SP',
            'insurance_number': 'UN987654321',
            'health_insurance_id': 1  # Unimed
        },
        {
            'name': 'João Pereira',
            'cpf': '987.654.321-00',
            'date_of_birth': date(1978, 3, 22),
            'gender': 'Masculino',
            'phone': '(11) 98765-1234',
            'email': 'joao.pereira@email.com',
            'address': 'Av. Paulista, 1000, São Paulo - SP',
            'insurance_number': 'AM123456789',
            'health_insurance_id': 2  # Amil
        },
        {
            'name': 'Ana Oliveira',
            'cpf': '456.789.123-00',
            'date_of_birth': date(1992, 10, 8),
            'gender': 'Feminino',
            'phone': '(11) 91234-5678',
            'email': 'ana.oliveira@email.com',
            'address': 'Rua Augusta, 500, São Paulo - SP',
            'insurance_number': 'SU456789123',
            'health_insurance_id': 3  # SulAmérica
        },
        {
            'name': 'Pedro Souza',
            'cpf': '789.123.456-00',
            'date_of_birth': date(1965, 5, 30),
            'gender': 'Masculino',
            'phone': '(11) 95678-9012',
            'email': 'pedro.souza@email.com',
            'address': 'Rua Oscar Freire, 300, São Paulo - SP',
            'insurance_number': 'BR789123456',
            'health_insurance_id': 4  # Bradesco Saúde
        },
        {
            'name': 'Luiza Costa',
            'cpf': '321.654.987-00',
            'date_of_birth': date(2000, 2, 10),
            'gender': 'Feminino',
            'phone': '(11) 99012-3456',
            'email': 'luiza.costa@email.com',
            'address': 'Rua dos Pinheiros, 100, São Paulo - SP',
            'insurance_number': 'ND321654987',
            'health_insurance_id': 5  # NotreDame Intermédica
        }
    ]
    
    query = """
        INSERT INTO patients (
            name, cpf, date_of_birth, gender, phone, email, address,
            insurance_number, health_insurance_id
        )
        VALUES (
            %(name)s, %(cpf)s, %(date_of_birth)s, %(gender)s, %(phone)s, 
            %(email)s, %(address)s, %(insurance_number)s, %(health_insurance_id)s
        )
        ON CONFLICT (cpf) DO NOTHING
        RETURNING id
    """
    
    patient_ids = []
    for patient in patients:
        result = execute_query(query, patient)
        if result:
            patient_ids.append(result[0]['id'])
    
    logger.info(f"Seeded {len(patient_ids)} patients")
    
    # Create appointments and medical records for patients
    if patient_ids:
        seed_appointments_and_records(patient_ids)

def seed_appointments_and_records(patient_ids):
    """Seed appointments and medical records for patients"""
    if not patient_ids:
        return
    
    # Get doctor and specialty data
    doctor_query = """
        SELECT d.id, d.name, ds.specialty_id
        FROM doctors d
        JOIN doctor_specialties ds ON d.id = ds.doctor_id
    """
    doctor_result = execute_query(doctor_query)
    
    if not doctor_result:
        return
    
    today = date.today()
    appointments = []
    
    statuses = ['scheduled', 'completed', 'no-show', 'cancelled']
    
    # Create past and future appointments
    for patient_id in patient_ids:
        # 2-4 appointments per patient
        num_appointments = random.randint(2, 4)
        
        for i in range(num_appointments):
            # Randomly select doctor and specialty
            doctor_data = random.choice(doctor_result)
            
            # Random date between 60 days ago and 30 days in the future
            days_offset = random.randint(-60, 30)
            appointment_date = today + timedelta(days=days_offset)
            
            # Random time between 8:00 and 17:00
            hour = random.randint(8, 17)
            minute = random.choice([0, 15, 30, 45])
            appointment_time = f"{hour:02d}:{minute:02d}:00"
            
            # Status based on date
            if days_offset < 0:
                status = 'completed' if random.random() < 0.8 else random.choice(['no-show', 'cancelled'])
            else:
                status = 'scheduled'
            
            appointment = {
                'patient_id': patient_id,
                'doctor_id': doctor_data['id'],
                'specialty_id': doctor_data['specialty_id'],
                'scheduled_date': appointment_date,
                'scheduled_time': appointment_time,
                'duration_minutes': 30,
                'status': status,
                'notes': f"Appointment for patient {patient_id} with {doctor_data['name']}"
            }
            
            appointments.append(appointment)
    
    # Insert appointments
    appointment_query = """
        INSERT INTO appointments (
            patient_id, doctor_id, specialty_id, scheduled_date, scheduled_time,
            duration_minutes, status, notes
        )
        VALUES (
            %(patient_id)s, %(doctor_id)s, %(specialty_id)s, %(scheduled_date)s,
            %(scheduled_time)s, %(duration_minutes)s, %(status)s, %(notes)s
        )
        RETURNING id
    """
    
    appointment_ids = []
    for appointment in appointments:
        result = execute_query(appointment_query, appointment)
        if result:
            appointment_id = result[0]['id']
            appointment_ids.append((appointment_id, appointment))
    
    logger.info(f"Seeded {len(appointment_ids)} appointments")
    
    # Create medical records for completed appointments
    seed_medical_records(appointment_ids)

def seed_medical_records(appointment_data):
    """Seed medical records for completed appointments"""
    if not appointment_data:
        return
    
    medical_records = []
    
    # Sample symptoms, diagnoses, and treatments
    symptoms_list = [
        "Dor de cabeça e febre",
        "Dor abdominal e náuseas",
        "Tosse e congestão nasal",
        "Dor nas costas",
        "Fadiga e mal-estar",
        "Dificuldade para respirar",
        "Tonturas e desmaios",
        "Dor no peito ao realizar esforços físicos"
    ]
    
    diagnoses_list = [
        "Gripe",
        "Infecção intestinal",
        "Hipertensão",
        "Enxaqueca",
        "Lombalgia",
        "Síndrome do intestino irritável",
        "Ansiedade",
        "Suspeita de angina estável"
    ]
    
    treatments_list = [
        "Repouso e hidratação",
        "Medicação para dor e anti-inflamatórios",
        "Antibióticos por 7 dias",
        "Mudanças na dieta",
        "Fisioterapia",
        "Acompanhamento psicológico",
        "AAS 100mg 1x/dia, Atenolol 25mg 1x/dia",
        "Solicitação de exames complementares"
    ]
    
    follow_ups_list = [
        "Retorno em 7 dias",
        "Retorno em 15 dias com resultados dos exames",
        "Acompanhamento mensal",
        "Retorno se sintomas persistirem",
        "Encaminhamento para especialista",
        "Nova avaliação em 30 dias"
    ]
    
    for appointment_id, appointment in appointment_data:
        # Only create records for completed appointments
        if appointment['status'] != 'completed':
            continue
        
        # Random elements
        symptoms = random.choice(symptoms_list)
        diagnosis = random.choice(diagnoses_list)
        treatment = random.choice(treatments_list)
        follow_up = random.choice(follow_ups_list)
        
        # Generate AI summary
        ai_summary = f"O paciente apresentou {symptoms.lower()}. Foi diagnosticado com {diagnosis.lower()}. O tratamento prescrito foi: {treatment}."
        
        record = {
            'patient_id': appointment['patient_id'],
            'appointment_id': appointment_id,
            'doctor_id': appointment['doctor_id'],
            'consultation_date': appointment['scheduled_date'],
            'symptoms': symptoms,
            'diagnosis': diagnosis,
            'treatment': treatment,
            'follow_up': follow_up,
            'digitized_from_physical': False,
            'ai_summary': ai_summary
        }
        
        medical_records.append(record)
    
    # Insert medical records
    if medical_records:
        record_query = """
            INSERT INTO medical_records (
                patient_id, appointment_id, doctor_id, consultation_date,
                symptoms, diagnosis, treatment, follow_up,
                digitized_from_physical, ai_summary
            )
            VALUES (
                %(patient_id)s, %(appointment_id)s, %(doctor_id)s, %(consultation_date)s,
                %(symptoms)s, %(diagnosis)s, %(treatment)s, %(follow_up)s,
                %(digitized_from_physical)s, %(ai_summary)s
            )
        """
        
        execute_batch(record_query, medical_records)
        logger.info(f"Seeded {len(medical_records)} medical records")

def main():
    """Main function to seed the database"""
    print("Seeding database with test data...")
    
    try:
        # Seed data in order of dependencies
        seed_specialties()
        seed_insurance_plans()
        seed_doctors()
        seed_patients()
        
        print("Database seeding completed successfully!")
    except Exception as e:
        logger.error(f"Error seeding database: {str(e)}")
        print(f"Error seeding database: {str(e)}")

if __name__ == "__main__":
    main() 