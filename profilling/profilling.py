import os
import pandas as pd
from sqlalchemy import create_engine
from ydata_profiling import ProfileReport

# Buat folder reports jika belum ada
os.makedirs("reports", exist_ok=True)

engine = create_engine(
    "postgresql://postgres:kukang12@localhost:5432/brazillian_ecommerce"
)

# Ambil semua tabel di schema public
tables = pd.read_sql("""
    SELECT table_name
    FROM information_schema.tables
    WHERE table_schema = 'public'
""", engine)

for table in tables["table_name"]:
    print(f"Profiling {table}...")

    df = pd.read_sql(f"SELECT * FROM {table}", engine)

    profile = ProfileReport(
        df,
        title=f"Profiling Report - {table}"
    )

    profile.to_file(f"reports/{table}.html")

print("Selesai!")