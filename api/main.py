from fastapi import FastAPI

import psycopg2

app = FastAPI()

def get_db_connection():
    conn = psycopg2.connect(host='localhost',
                            database='hawaii',
                            user=os.environ['PGUSER'],
                            password=os.environ['PGPASSWORD'])
    return conn
@app.get("/")
async def root():
    return {"message": "Hello World"} 


@app.get("/estimate/cell/{cell_id}/user/{user_id}")
async def read_estimate(cell_id: int, user_id: int):
    return {"cell_id": cell_id, "user_id": user_id}

class Estimate:
    cell_id: int
    user_id: int
    estimate: int
    notes: str

@app.post("/estimate", status_code=201)
async def save_estimate(cell_id: int, user_id: int, estimate: int, notes: str):
    return {"cell_id": cell_id, "user_id": user_id, "estimate": estimate, "notes": notes}
