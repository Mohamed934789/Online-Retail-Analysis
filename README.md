# 📊 Retail Sales & Revenue Analysis Dashboard

## 📌 Project Overview

This project analyzes an **online retail dataset** to understand sales performance, customer behavior, and product contribution to revenue.

The goal is to transform raw transactional data into **actionable business insights** using a combination of:

- Python for data preparation and exploration
- SQL Server for analytical queries
- Power BI for interactive dashboards

The project demonstrates an end-to-end **data analytics workflow** from raw data to decision-ready insights.

---

# 🧰 Tools & Technologies

| Tool | Purpose |
|-----|------|
| Python | Data Cleaning & Feature Engineering |
| Pandas | Data Manipulation |
| Matplotlib / Seaborn | Data Visualization |
| SQL Server | Analytical Queries |
| Power BI | Dashboard Development |
| SQLAlchemy | Python–SQL integration |

---

# 📂 Dataset

The dataset contains **transactional data from an online retail store**, including:

| Column | Description |
|------|-------------|
| Invoice | Unique transaction ID |
| Product | Product name |
| Quantity | Number of items purchased |
| Price | Price per item |
| InvoiceDate | Date of purchase |
| Customer ID | Unique customer identifier |
| Country | Customer location |
| Total_Price | Revenue per transaction |

Additional columns were engineered during the analysis such as:

- Year
- Month
- Day
- Total_Price

---

# ⚙️ Data Preparation (Python)

Python was used for:

- Cleaning missing customer IDs
- Removing cancelled transactions
- Creating derived features
- Calculating revenue metrics
- Exporting cleaned data to SQL Server

Example code:

```python
from sqlalchemy import create_engine

engine = create_engine(
    "mssql+pyodbc://localhost/SQLEXPRESS/Online_Retail?driver=ODBC+Driver+17+for+SQL+Server"
)

df.to_sql(
    name='sales_table',
    con=engine,
    if_exists='replace',
    index=False
)
