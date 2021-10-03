from fastapi import APIRouter

router = APIRouter()


# @router.get("/users/{user_id}")
@router.get("/")
async def user():
    return {"message": "Get User"}
