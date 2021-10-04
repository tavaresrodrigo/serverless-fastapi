from fastapi import APIRouter

router = APIRouter()


# Get users
@router.get("/")
async def user():
    return {"message": "Get Coins"}
