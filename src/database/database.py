import os
import logging
from typing import AsyncGenerator, List, Dict, Any, Optional
from dotenv import load_dotenv
import asyncpg
from contextlib import asynccontextmanager
from asyncpg.pool import Pool

logger = logging.getLogger(__name__)

# Load environment variables
load_dotenv()

# Get database connection parameters from environment variables
DB_HOST = os.getenv("DB_HOST", "localhost")
DB_PORT = int(os.getenv("DB_PORT", "5432"))
DB_NAME = os.getenv("DB_NAME", "clinic")
DB_USER = os.getenv("DB_USER", "postgres")
DB_PASSWORD = os.getenv("DB_PASSWORD", "1234")

# Connection pool
pool: Optional[Pool] = None

async def get_connection_pool() -> Pool:
    """Get the database connection pool."""
    global pool
    if pool is None:
        logger.info("Creating database connection pool")
        try:
            pool = await asyncpg.create_pool(
                host=DB_HOST,
                port=DB_PORT,
                database=DB_NAME,
                user=DB_USER,
                password=DB_PASSWORD,
                min_size=5,
                max_size=20,
            )
            logger.info("Database connection pool created successfully")
        except Exception as e:
            logger.error(f"Failed to create database connection pool: {e}")
            raise
    return pool

async def close_connection_pool() -> None:
    """Close the database connection pool."""
    global pool
    if pool:
        logger.info("Closing database connection pool")
        await pool.close()
        pool = None
        logger.info("Database connection pool closed")

@asynccontextmanager
async def get_db_connection() -> AsyncGenerator[asyncpg.Connection, None]:
    """Context manager for database connections."""
    pool = await get_connection_pool()
    async with pool.acquire() as connection:
        try:
            yield connection
        except Exception as e:
            logger.error(f"Database operation failed: {e}")
            raise

async def initialize_database() -> None:
    """Initialize the database connection pool and ensure schema is created."""
    global pool
    try:
        # Get database connection details from environment variables
        host = os.getenv("DB_HOST", "localhost")
        port = int(os.getenv("DB_PORT", "5432"))
        user = os.getenv("DB_USER", "postgres")
        password = os.getenv("DB_PASSWORD", "postgres")
        database = os.getenv("DB_NAME", "clinic")

        # Create connection pool
        pool = await asyncpg.create_pool(
            host=host,
            port=port,
            user=user,
            password=password,
            database=database,
            min_size=5,
            max_size=20
        )
        
        logger.info("Database connection pool initialized")
        
        # Initialize schema if needed
        await initialize_schema()
        
    except Exception as e:
        logger.error(f"Failed to initialize database: {e}")
        raise

async def initialize_schema() -> None:
    """Initialize the database schema using schema.sql file."""
    try:
        if pool is None:
            raise ValueError("Database pool not initialized")
            
        # Read schema SQL file
        schema_path = os.path.join(os.path.dirname(__file__), "schema.sql")
        with open(schema_path, "r") as f:
            schema_sql = f.read()
            
        # Execute schema SQL
        async with pool.acquire() as conn:
            await conn.execute(schema_sql)
            
        logger.info("Database schema initialized")
        
    except Exception as e:
        logger.error(f"Failed to initialize schema: {e}")
        raise

async def execute_query(query: str, *args: Any) -> List[Dict[str, Any]]:
    """Execute a query and return the results as a list of dictionaries."""
    if pool is None:
        raise ValueError("Database pool not initialized")
        
    try:
        async with pool.acquire() as conn:
            results = await conn.fetch(query, *args)
            return [dict(row) for row in results]
    except Exception as e:
        logger.error(f"Query execution failed: {e}")
        logger.error(f"Query: {query}")
        raise

async def execute_transaction(queries: List[Dict[str, Any]]) -> List[List[Dict[str, Any]]]:
    """Execute multiple queries in a transaction.
    
    Args:
        queries: List of dictionaries with 'query' and 'args' keys
        
    Returns:
        List of results for each query
    """
    if pool is None:
        raise ValueError("Database pool not initialized")
        
    results = []
    try:
        async with pool.acquire() as conn:
            async with conn.transaction():
                for query_info in queries:
                    query = query_info['query']
                    args = query_info.get('args', [])
                    query_result = await conn.fetch(query, *args)
                    results.append([dict(row) for row in query_result])
        return results
    except Exception as e:
        logger.error(f"Transaction execution failed: {e}")
        for query_info in queries:
            logger.error(f"Query in transaction: {query_info['query']}")
        raise

async def fetch_one(query: str, *args) -> Optional[Dict[str, Any]]:
    """Fetch a single row as a dictionary."""
    async with get_db_connection() as conn:
        row = await conn.fetchrow(query, *args)
        return dict(row) if row else None

async def fetch_all(query: str, *args) -> List[Dict[str, Any]]:
    """Fetch all rows as a list of dictionaries."""
    async with get_db_connection() as conn:
        rows = await conn.fetch(query, *args)
        return [dict(row) for row in rows]

async def execute_many(query: str, args_list: List[tuple]) -> None:
    """Execute the same query with different arguments."""
    async with get_db_connection() as conn:
        await conn.executemany(query, args_list)

@asynccontextmanager
async def get_transaction():
    """Get a database transaction."""
    async with get_db_connection() as conn:
        async with conn.transaction():
            yield conn 