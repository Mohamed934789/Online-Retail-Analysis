# 📊 Retail Sales & Revenue Analysis Dashboard

![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)
![SQL Server](https://img.shields.io/badge/SQL%20Server-CC2927?style=for-the-badge&logo=microsoft-sql-server&logoColor=white)
![Power BI](https://img.shields.io/badge/Power%20BI-F2C811?style=for-the-badge&logo=power-bi&logoColor=black)
![Pandas](https://img.shields.io/badge/Pandas-150458?style=for-the-badge&logo=pandas&logoColor=white)

## 📌 Project Overview
This project features a comprehensive **End-to-End Data Analytics Workflow** applied to an online retail dataset. The objective was to transform raw transactional data into actionable business intelligence to drive strategic decision-making.

### 🎯 Key Objectives:
* **Data Engineering:** Clean and structure raw messy data using Python.
* **Analytical Deep-Dive:** Perform complex SQL queries for RFM analysis and customer behavior.
* **Data Visualization:** Build an interactive Power BI dashboard to track KPIs and trends.

---

## 🧰 Tech Stack
| Category | Tools |
| :--- | :--- |
| **Data Processing** | Python (Pandas, NumPy) |
| **Database Management** | SQL Server (T-SQL), SQLAlchemy |
| **Visualization** | Power BI, Matplotlib, Seaborn |
| **Environment** | Jupyter Notebook, SQL Server Management Studio (SSMS) |

---

## 📂 Dataset Architecture
The analysis is based on transactional records with the following core attributes:
* **Transaction Info:** `Invoice`, `InvoiceDate`, `Quantity`, `Price`
* **Product Info:** `Product Description`, `StockCode`
* **Customer Info:** `Customer ID`, `Country`
* **Engineered Features:** `Total_Price`, `Year`, `Month`, `Day`, `RFM_Score`

---

## ⚙️ Data Pipeline

### 1. Cleaning & ETL (Python)
Raw data was processed to ensure integrity:
* Handled missing values in `Customer ID`.
* Filtered out cancelled transactions (Returns).
* Standardized data types and exported to **SQL Server** for persistence.

```python
# Quick snippet of the SQL Integration
from sqlalchemy import create_engine
engine = create_engine("mssql+pyodbc://localhost/SQLEXPRESS/Online_Retail?driver=ODBC+Driver+17+for+SQL+Server")
df.to_sql('sales_table', con=engine, if_exists='replace', index=False)
