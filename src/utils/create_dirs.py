import os
import logging

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(name)s - %(levelname)s - %(message)s",
)
logger = logging.getLogger(__name__)

def create_required_directories():
    """Create all required directories if they don't exist"""
    directories = [
        "src/routes",
        "src/database",
        "src/ai_integration",
        "src/utils",
        "uploads",
        "uploads/documents",
        "uploads/images",
        "logs",
    ]
    
    for directory in directories:
        try:
            if not os.path.exists(directory):
                os.makedirs(directory)
                logger.info(f"Created directory: {directory}")
        except Exception as e:
            logger.error(f"Failed to create directory {directory}: {str(e)}")

if __name__ == "__main__":
    create_required_directories() 