from pydantic import BaseModel

class Order(BaseModel):
    orderId: str
    orderDate: str
    coinId: str
    coinName: str
    coinUnities: float
    coinPurchasePrice: float
    coinBEP: float
   