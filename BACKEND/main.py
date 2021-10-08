from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from mangum import Mangum
from mangum.types import Response
from model import Order
from pydantic import BaseModel
from database import (fetch_all_orders, fetch_one_order, create_order, update_order, remove_order)
import boto3

app = FastAPI()
origins = ['https://localhost:3000']
app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials = True,
    allow_methods=["*"],
    allow_headers=["*"],
)

dynamodb = boto3.client('dynamodb', region_name='localhost', endpoint_url='http://localhost:8000')


@app.get("/")
async def root():
    return {"message": "Hello"}

@app.get("/api/order")
async def get_order():
    response = await fetch_all_orders()
    return response

# Get orders per coindID
@app.get("/api/order{coin_id}", response_model=Order)
async def get_order_by_id(coin_id):
    response = await fetch_one_order(coin_id)
    if response:
        return response
    raise HTTPExption(404, f"There is no order with the coind id {coin_id}")

@app.post("/api/order", response_model=Order)
async def post_order(order: Order):
    response = await create_order(order.dict())
    if response:
        return response
    raise HTTPExption(400, f"There was a problem including your order.")

@app.put("/api/order", response_model=Order)
async def post_order():
    response = await update_order()
    if response:
        return response
    raise HTTPExption(404, f"There was a problem updating your order.")

@app.delete("/api/order{order_id}")
async def delete_order(order_id):
    response = await remove_order(order_id)
    if response:
        return "Order deletes sucessfully"
    raise HTTPExption(404, f"There was a problem removing your order.")

handler = Mangum(app)