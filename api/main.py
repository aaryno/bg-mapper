# uvicorn main:app --reload
from fastapi import FastAPI
import databases
import sqlalchemy
from pydantic import BaseModel
import datetime


# DATABASE_URL = "sqlite:///./test.db"
DATABASE_URL = "postgresql://postgres:postgres@localhost:5432/estimates"

database = databases.Database(DATABASE_URL)

app = FastAPI()

engine = sqlalchemy.create_engine(DATABASE_URL)  # Access the DB Engine

metadata = sqlalchemy.MetaData(engine)

estimates = sqlalchemy.Table(
    "estimates",
    metadata,
    sqlalchemy.Column("estimate_id", sqlalchemy.Integer, primary_key=True),
    sqlalchemy.Column("cell_id", sqlalchemy.Integer),
    sqlalchemy.Column("user_id", sqlalchemy.Integer),
    sqlalchemy.Column("estimate", sqlalchemy.Integer),
    sqlalchemy.Column(
        "observation_time", sqlalchemy.DateTime, default=datetime.datetime.utcnow
    ),
    sqlalchemy.Column("notes", sqlalchemy.String),
)

metadata.create_all()


class Estimate(BaseModel):
    cell_id: int
    user_id: int
    estimate: int
    observation_time: datetime.datetime
    notes: str


@app.on_event("startup")
async def startup():
    await database.connect()


@app.on_event("shutdown")
async def shutdown():
    await database.disconnect()


@app.get("/estimate/cell/{cell_id}/user/{user_id}", response_model=Estimate)
async def read_estimate(cell_id: int, user_id: int):
    query = estimates.select().where(
        sqlalchemy.and_(estimates.c.cell_id == cell_id, estimates.c.user_id == user_id)
    )
    return await database.fetch_one(query)


@app.post("/estimate", status_code=201, response_model=Estimate)
async def save_estimate(estimate: Estimate):
    query = estimates.insert().values(
        cell_id=estimate.cell_id,
        user_id=estimate.user_id,
        estimate=estimate.estimate,
        observation_time=datetime.datetime.utcnow(),
        notes=estimate.notes,
    )
    last_record_id = await database.execute(query)
    return {**estimate.dict(), "id": last_record_id}
