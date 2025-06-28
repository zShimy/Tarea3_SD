import csv
from pymongo import MongoClient

MONGO_URI = "mongodb://mongo:27017"
DB_NAME = "eventos_waze"
COLLECTION_NAME = "eventos"
OUTPUT_FILE = "/data/eventos.csv"

client = MongoClient(MONGO_URI)
db = client[DB_NAME]
collection = db[COLLECTION_NAME]

fields = [
    "evento_id",
    "tipo",
    "subtipo",
    "ubicacion.calle",
    "ubicacion.coordenadas.lat",
    "ubicacion.coordenadas.lon",
    "timestamp",
    "fecha_evento",
    "hora_evento",
    "fuente",
    "procesado"
]

def flatten(doc):
    return {
        "evento_id": doc.get("evento_id", ""),
        "tipo": doc.get("tipo", ""),
        "subtipo": doc.get("subtipo", ""),
        "calle": doc.get("ubicacion", {}).get("calle", ""),
        "lat": doc.get("ubicacion", {}).get("coordenadas", {}).get("lat", ""),
        "lon": doc.get("ubicacion", {}).get("coordenadas", {}).get("lon", ""),
        "timestamp": doc.get("timestamp", ""),
        "fecha_evento": doc.get("fecha_evento", ""),
        "hora_evento": doc.get("hora_evento", ""),
        "fuente": doc.get("fuente", ""),
        "procesado": doc.get("procesado", "")
    }

with open(OUTPUT_FILE, "w", newline="", encoding="utf-8") as csvfile:
    writer = csv.DictWriter(csvfile, fieldnames=[
        "evento_id", "tipo", "subtipo", "calle", "lat", "lon",
        "timestamp", "fecha_evento", "hora_evento", "fuente", "procesado"
    ])
    writer.writeheader()
    for doc in collection.find():
        writer.writerow(flatten(doc))

print(f"Exported events to {OUTPUT_FILE}")
