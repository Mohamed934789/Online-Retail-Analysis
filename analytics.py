"""Retail measures with explicit line/invoice and gross/net definitions."""
from pathlib import Path
import pandas as pd

def load(path):
    path = Path(path)
    if not path.exists(): raise FileNotFoundError("Run scripts/download_data.py or supply an authorized input workbook")
    if path.suffix.lower() == ".csv": return pd.read_csv(path)
    sheets = pd.read_excel(path, sheet_name=None)
    return pd.concat(sheets.values(), ignore_index=True)

def prepare(frame):
    frame = frame.rename(columns={"InvoiceNo":"Invoice", "UnitPrice":"Price", "CustomerID":"Customer ID"}).copy()
    required = {"Invoice", "InvoiceDate", "Quantity", "Price", "Country", "Description"}
    if not required <= set(frame): raise ValueError("Required retail columns are missing")
    frame = frame.drop_duplicates()
    frame["InvoiceDate"] = pd.to_datetime(frame["InvoiceDate"], errors="coerce")
    for col in ["Quantity", "Price"]: frame[col] = pd.to_numeric(frame[col], errors="coerce")
    if frame[["InvoiceDate", "Quantity", "Price"]].isna().any().any(): raise ValueError("Invalid dates/amounts require review")
    frame["Invoice"] = frame["Invoice"].astype(str)
    frame["is_cancelled"] = frame["Invoice"].str.upper().str.startswith("C")
    frame["Total_Price"] = frame["Quantity"] * frame["Price"]
    frame["Year"] = frame["InvoiceDate"].dt.year
    frame["Month"] = frame["InvoiceDate"].dt.month
    return frame

def monthly_net(frame):
    return frame.groupby(frame["InvoiceDate"].dt.to_period("M"))["Total_Price"].sum().sort_index()

def cancellation_counts(frame):
    return frame.loc[frame["is_cancelled"]].groupby("Year")["Invoice"].nunique()

def customer_rfm(frame):
    purchases = frame.loc[(~frame["is_cancelled"]) & (frame["Quantity"] > 0) & (frame["Price"] > 0)].dropna(subset=["Customer ID"])
    reference = purchases["InvoiceDate"].max().normalize() + pd.Timedelta(days=1)
    result = purchases.groupby("Customer ID").agg(last_purchase=("InvoiceDate","max"), frequency=("Invoice","nunique"), monetary=("Total_Price","sum"))
    result["recency_days"] = (reference - result.pop("last_purchase")).dt.days
    return result
