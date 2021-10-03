from fastapi import FastAPI
from starlette.responses import FileResponse
from app.api.api_v1.api import router as api_router

app = FastAPI()

@app.get("/")
async def root():
    return {"message": "Hello Rodrigo"}


app.include_router(api_router, prefix='/api/v1')