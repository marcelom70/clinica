import os
import logging
from typing import Dict, Any, Optional, List, Tuple
import asyncpg
from asyncpg.pool import Pool

logger = logging.getLogger(__name__)

# Database connection details
DATABASE_URL = os.getenv("DATABASE_URL", "postgresql://postgres:1234@localhost:5432/clinica_medica_dev")

# Connection pool
db_pool: Pool = None

async def get_connection_pool() -> Pool:
    """Get the database connection pool. Creates it if it doesn't exist."""
    global db_pool
    if db_pool is None:
        await init_db()
    return db_pool

async def init_db() -> None:
    """Initialize the database connection pool."""
    global db_pool
    
    try:
        logger.info("Creating database connection pool...")
        db_pool = await asyncpg.create_pool(
            DATABASE_URL,
            min_size=5,
            max_size=20,
            timeout=30
        )
        logger.info("Database connection pool created successfully")
        
        # Test connection
        async with db_pool.acquire() as conn:
            version = await conn.fetchval("SELECT version()")
            logger.info(f"Connected to the database. {version}")
            
    except Exception as e:
        logger.error(f"Failed to create database connection pool: {str(e)}")
        raise

async def close_db() -> None:
    """Close the database connection pool."""
    global db_pool
    if db_pool:
        logger.info("Closing database connection pool...")
        await db_pool.close()
        db_pool = None
        logger.info("Database connection pool closed")

def _convert_params_to_args(query: str, params: Optional[Dict[str, Any]] = None) -> Tuple[str, List[Any]]:
    """Convert named parameters to positional parameters for asyncpg."""
    if not params:
        return query, []
    
    # Replace named parameters %(name)s with $1, $2, etc.
    args = []
    param_names = {}
    
    # Find all %(name)s parameters
    import re
    pattern = r'%\(([^)]+)\)s'
    matches = re.findall(pattern, query)
    
    # Create a map of parameter names to positions
    for i, name in enumerate(matches):
        if name not in param_names:
            param_names[name] = i + 1
            args.append(params[name])
    
    # Replace %(name)s with $position
    for name, position in param_names.items():
        placeholder = f'%({name})s'
        query = query.replace(placeholder, f'${position}')
    
    return query, args

async def execute_query(query: str, params: Optional[Dict[str, Any]] = None, fetch: bool = True) -> Any:
    """Execute a database query and return the result."""
    pool = await get_connection_pool()
    async with pool.acquire() as conn:
        query, args = _convert_params_to_args(query, params)
        if fetch:
            return await conn.fetch(query, *args)
        else:
            return await conn.execute(query, *args)

async def execute_transaction(queries: list) -> None:
    """Execute multiple queries in a transaction."""
    pool = await get_connection_pool()
    async with pool.acquire() as conn:
        async with conn.transaction():
            for query, params in queries:
                query, args = _convert_params_to_args(query, params)
                await conn.execute(query, *args)

async def fetch_one(query: str, params: Optional[Dict[str, Any]] = None) -> Dict[str, Any]:
    """Fetch a single row from the database."""
    pool = await get_connection_pool()
    async with pool.acquire() as conn:
        query, args = _convert_params_to_args(query, params)
        row = await conn.fetchrow(query, *args)
        return dict(row) if row else None

async def fetch_all(query: str, params: Optional[Dict[str, Any]] = None) -> list:
    """Fetch all rows from the database."""
    pool = await get_connection_pool()
    async with pool.acquire() as conn:
        query, args = _convert_params_to_args(query, params)
        rows = await conn.fetch(query, *args)
        return [dict(row) for row in rows]

async def execute(query: str, params: Optional[Dict[str, Any]] = None) -> str:
    """Execute a query and return the status."""
    pool = await get_connection_pool()
    async with pool.acquire() as conn:
        query, args = _convert_params_to_args(query, params)
        return await conn.execute(query, *args) 