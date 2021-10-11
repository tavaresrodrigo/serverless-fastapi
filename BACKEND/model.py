from typing import Optional
from pydantic import BaseModel
from datetime import datetime

class Order(BaseModel):
    orderId: int
    orderDate: Optional[datetime] = None
    coinId: str
    coinUnities: float
    coinPurchasePrice: float
   