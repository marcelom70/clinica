import os
import asyncio
import logging
import sys

# Add parent directory to path to import modules
sys.path.append(os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))))

from src.database.connection import init_db, close_db, get_connection_pool

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(name)s - %(levelname)s - %(message)s",
)
logger = logging.getLogger(__name__)

async def initialize_database():
    """Initialize the database by running the schema.sql file"""
    try:
        # Connect to the database
        await init_db()
        
        # Read and execute schema.sql
        schema_path = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), 
                                  "database", "schema.sql")
        
        with open(schema_path, 'r') as f:
            sql_schema = f.read()
        
        logger.info("Executing database schema...")
        
        # Get a raw connection from the pool to execute the script directly
        pool = await get_connection_pool()
        async with pool.acquire() as conn:
            # Execute the SQL script directly without using a prepared statement
            await conn.execute(sql_schema)
        
        logger.info("Database schema executed successfully")
        
        # Close the database connection
        await close_db()
        
        logger.info("Database initialization completed successfully")
    except Exception as e:
        logger.error(f"Error initializing database: {str(e)}")
        raise

if __name__ == "__main__":
    asyncio.run(initialize_database()) 