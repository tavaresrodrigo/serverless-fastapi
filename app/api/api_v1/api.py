from fastapi import APIRouter

from .endpoints import coins

router = APIRouter()
router.include_router(coins.router, prefix="/coins", tags=["coins"])