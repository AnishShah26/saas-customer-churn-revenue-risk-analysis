import sqlite3
import pandas as pd
from pathlib import Path

# Project paths
BASE_DIR = Path(__file__).resolve().parents[1]
DATA_RAW = BASE_DIR / "data_raw"
DATABASE_DIR = BASE_DIR / "database"
DATABASE_DIR.mkdir(exist_ok=True)

DB_PATH = DATABASE_DIR / "ravenstack.db"

# CSV files and matching table names
csv_to_table = {
    "ravenstack_accounts.csv": "accounts",
    "ravenstack_subscriptions.csv": "subscriptions",
    "ravenstack_feature_usage.csv": "feature_usage",
    "ravenstack_support_tickets.csv": "support_tickets",
    "ravenstack_churn_events.csv": "churn_events",
}

def load_csv_to_sqlite():
    conn = sqlite3.connect(DB_PATH)

    for csv_file, table_name in csv_to_table.items():
        file_path = DATA_RAW / csv_file

        if not file_path.exists():
            raise FileNotFoundError(f"Missing file: {file_path}")

        df = pd.read_csv(file_path)
        df.to_sql(table_name, conn, if_exists="replace", index=False)

        print(f"Loaded {len(df):,} rows into table: {table_name}")

    conn.close()
    print(f"\nDatabase created successfully at: {DB_PATH}")

if __name__ == "__main__":
    load_csv_to_sqlite()