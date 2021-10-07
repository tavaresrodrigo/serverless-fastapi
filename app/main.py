from fastapi import FastAPI
from app.api.api_v1.api import router as api_router
from mangum import Mangum
from app.model import Order
from pydantic import BaseModel
import boto3
dynamodb = boto3.client('dynamodb', region_name='localhost', endpoint_url='http://localhost:8000')

app = FastAPI()

@app.get("/")
async def root():
    return {"message": "Hello Rodrigo"}

@app.post("/temperature")
async def create_order(order: Order):
    order_item = {order}
    return order_item

app.include_router(api_router, prefix='/api/v1')
handler = Mangum(app)