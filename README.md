# 📊 Retail Sales & Revenue Analysis Dashboard

![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)
![SQL Server](https://img.shields.io/badge/SQL%20Server-CC2927?style=for-the-badge&logo=microsoft-sql-server&logoColor=white)
![Power BI](https://img.shields.io/badge/Power%20BI-F2C811?style=for-the-badge&logo=power-bi&logoColor=black)

---

## 📌 Project Overview

This project analyzes an **online retail dataset** to understand sales performance, customer behavior, and product contribution to revenue.

The goal is to transform raw transactional data into **actionable business insights** using a combination of:

- 🐍 Python for data preparation and exploration
- 🗄️ SQL Server for analytical queries
- 📊 Power BI for interactive dashboards

The project demonstrates an end-to-end **data analytics workflow** — from raw data to decision-ready insights.

---

## 🧰 Tools & Technologies

| Tool | Purpose |
|------|---------|
| Python | Data Cleaning & Feature Engineering |
| Pandas | Data Manipulation |
| Matplotlib / Seaborn | Data Visualization |
| SQL Server | Analytical Queries |
| Power BI | Dashboard Development |
| SQLAlchemy | Python–SQL Integration |

---

## 📂 Dataset

| Column | Description |
|--------|-------------|
| `Invoice` | Unique transaction ID |
| `Product` | Product name |
| `Quantity` | Number of items purchased |
| `Price` | Price per item |
| `InvoiceDate` | Date of purchase |
| `Customer ID` | Unique customer identifier |
| `Country` | Customer location |
| `Total_Price` | Revenue per transaction |

> Additional columns engineered during analysis: `Year`, `Month`, `Day`, `Total_Price`

---

## ⚙️ Data Preparation (Python)

- ✅ Cleaning missing Customer IDs
- ✅ Removing cancelled transactions
- ✅ Creating derived features
- ✅ Calculating revenue metrics
- ✅ Exporting cleaned data to SQL Server
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
```

---

## 🗄️ SQL Analysis

### 👤 Customer Analysis
```sql
SELECT TOP 10
    [Customer ID],
    COUNT(DISTINCT Invoice) AS Number_Of_Orders,
    SUM(Total_Price) AS Total_Revenue
FROM sales_table
GROUP BY [Customer ID]
ORDER BY Total_Revenue DESC;
```

### 📦 Product Analysis
```sql
SELECT TOP 10
    Product,
    SUM(Total_Price) AS Product_Revenue
FROM sales_table
GROUP BY Product
ORDER BY Product_Revenue DESC;
```

### 🎯 Customer Segmentation (RFM)
```sql
SELECT
    s.[Customer ID],
    DATEDIFF(day, MAX(s.InvoiceDate), m.Max_InvoiceDate) AS Recency_Days,
    COUNT(DISTINCT Invoice) AS Frequency,
    SUM(Total_Price) AS Monetary
FROM sales_table s
CROSS JOIN (
    SELECT MAX(InvoiceDate) AS Max_InvoiceDate
    FROM sales_table
) m
GROUP BY s.[Customer ID], m.Max_InvoiceDate;
```

---

## 📊 Power BI Dashboard

### 🔹 Overview Dashboard
- Monthly revenue trend
- Top selling products
- Return rate
- Top countries by revenue
- Key business metrics

![Overview Dashboard](images/overview_dashboard.png)

### 🔹 Sales Performance Dashboard
- Product contribution to revenue
- Top products
- Monthly order trends
- Orders distribution by country
- Return rate analysis

![Sales Dashboard](images/sales_dashboard.png)

### 🔹 Customer Behavior Dashboard
- Customer segmentation (RFM)
- Customer revenue contribution
- Top customers
- Customer growth over time

![Customer Dashboard](images/customer_dashboard.png)

---

## 🔑 Key Insights

| # | Insight |
|---|---------|
| 💰 | Revenue slightly declined in 2011 vs 2010 — decrease in **average order value** |
| 🌍 | **United Kingdom** dominates sales — heavy reliance on a single market |
| 📦 | Small number of products drive majority of revenue (*Regency Cakestand 3 Tier*, etc.) |
| 👑 | **Champions** segment contributes the largest share of revenue |
| 📅 | Sales peak in **October–November** — strong pre-holiday seasonal demand |

---

## 💡 Business Recommendations

1. 🎯 **Strengthen Customer Loyalty Programs** — Focus on Champions & Loyal Customers
2. 🌐 **Expand International Markets** — Reduce UK dependency
3. 📣 **Promote Top Products** — Use bundles and ad campaigns
4. 📦 **Prepare for Seasonal Demand** — Increase inventory before Q4
5. 🔄 **Reduce Return Rate** — Review product descriptions and quality control

---

## 📁 Project Structure
```
Retail-Sales-Analysis/
│
├── notebooks/
│   └── sales_analysis.ipynb
│
├── sql/
│   └── sales_queries.sql
│
├── dashboard/
│   └── powerbi_dashboard.pbix
│
├── images/
│   ├── overview_dashboard.png
│   ├── sales_dashboard.png
│   └── customer_dashboard.png
│
└── README.md
```

---

## 🚀 How to Run
```bash
# 1. Clone the repository
git clone https://github.com/yourusername/retail-sales-analysis

# 2. Install required libraries
pip install pandas matplotlib seaborn sqlalchemy pyodbc

# 3. Run the Jupyter Notebook
jupyter notebook notebooks/sales_analysis.ipynb

# 4. Execute SQL queries on SQL Server

# 5. Open the Power BI dashboard
```

---

## 👨‍💻 Author

**Kassab** — AI Student & Data Analyst

[![GitHub](https://img.shields.io/badge/GitHub-Follow-black?style=flat&logo=github)](https://github.com/yourusername)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-blue?style=flat&logo=linkedin)](https://linkedin.com/in/yourprofile)
