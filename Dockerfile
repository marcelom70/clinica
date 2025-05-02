# Use Python 3.10 as base image
FROM python:3.10-slim

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    postgresql-client \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements file
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Set environment variables
ENV PORT=8000
ENV HOST=0.0.0.0
ENV DEBUG=false
ENV DATABASE_URL=postgresql://postgres:1234@db:5432/clinica_medica_dev

# Expose port
EXPOSE 8000

# Command to run the application
CMD ["python", "run.py"]