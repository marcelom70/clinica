import os
import sys
import pytest
import asyncio
from asyncpg.pool import Pool

# Add parent directory to path to import modules
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from src.database.connection import init_db, close_db, get_connection_pool, execute_query, fetch_one, fetch_all

# Fixture for database connection
@pytest.fixture
async def db_pool():
    """Initialize and return a database connection pool."""
    await init_db()
    pool = get_connection_pool()
    yield pool
    await close_db()

@pytest.mark.asyncio
async def test_database_connection(db_pool):
    """Test that we can connect to the database."""
    assert db_pool is not None
    assert isinstance(db_pool, Pool)

@pytest.mark.asyncio
async def test_execute_query():
    """Test executing a simple query."""
    await init_db()
    
    # Simple test query
    result = await execute_query("SELECT 1 as test")
    
    assert result is not None
    assert len(result) == 1
    assert result[0]['test'] == 1
    
    await close_db()

@pytest.mark.asyncio
async def test_fetch_one():
    """Test fetching a single row."""
    await init_db()
    
    # Simple test query
    result = await fetch_one("SELECT 1 as test")
    
    assert result is not None
    assert result['test'] == 1
    
    await close_db()

@pytest.mark.asyncio
async def test_fetch_all():
    """Test fetching multiple rows."""
    await init_db()
    
    # Test query that returns multiple rows
    result = await fetch_all("SELECT generate_series(1, 3) as num")
    
    assert result is not None
    assert len(result) == 3
    assert result[0]['num'] == 1
    assert result[1]['num'] == 2
    assert result[2]['num'] == 3
    
    await close_db()

@pytest.mark.asyncio
async def test_parameterized_query():
    """Test executing a parameterized query."""
    await init_db()
    
    # Parameterized query
    param_value = 42
    result = await fetch_one("SELECT %(value)s as test", {"value": param_value})
    
    assert result is not None
    assert result['test'] == param_value
    
    await close_db() 