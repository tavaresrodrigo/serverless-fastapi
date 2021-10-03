from fastapi import FastAPI

app = FastAPI()

@app.get("/")
async def root():
    return {"message": "Hello Rodrigo"}

@app.get("/user")
async def user():
    return {"message": "Get User"}