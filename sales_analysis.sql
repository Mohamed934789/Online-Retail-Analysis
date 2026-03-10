/*============================================================
  SALES ANALYSIS PROJECT 
  Table: sales_table
============================================================*/


/*============================================================
  1) DATA UNDERSTANDING (Quick Checks)
============================================================*/

-- Preview data
SELECT *
FROM sales_table;

-- Latest invoice date in the dataset
SELECT MAX(InvoiceDate) AS Last_Invoice_Date
FROM sales_table;

-- Total revenue (Net / as stored in Total_Price)
SELECT SUM(Total_Price) AS Total_Revenue
FROM sales_table;


/*============================================================
  2) DATA PREPARATION (Column Naming)
============================================================*/

-- Rename column Description -> Product (only run once if needed)
EXEC sp_rename 'sales_table.Description', 'Product', 'column';


/*============================================================
  3) CUSTOMER ANALYSIS
============================================================*/

--------------------------------------------------------------
-- 3.1 Top 10 Customers by Revenue + Orders Count
--------------------------------------------------------------
SELECT TOP 10
    [Customer ID],
    COUNT(DISTINCT Invoice) AS Number_Of_Orders,
    SUM(Total_Price)        AS Total_Revenue
FROM sales_table
GROUP BY [Customer ID]
ORDER BY Total_Revenue DESC;


--------------------------------------------------------------
-- 3.2 Top 10 Customers by Number of Orders
--------------------------------------------------------------
SELECT TOP 10
    [Customer ID],
    COUNT(DISTINCT Invoice) AS Number_Of_Orders
FROM sales_table
GROUP BY [Customer ID]
ORDER BY Number_Of_Orders DESC;


--------------------------------------------------------------
-- 3.3 Filter: Specific Customer Orders Count (Example: 18102)
--------------------------------------------------------------
SELECT
    [Customer ID],
    COUNT(DISTINCT Invoice) AS Number_Of_Orders
FROM sales_table
WHERE [Customer ID] = 18102
GROUP BY [Customer ID];


--------------------------------------------------------------
-- 3.4 Customer Contribution to Total Sales (%)
--------------------------------------------------------------
SELECT
    [Customer ID],
    SUM(Total_Price) AS Customer_Revenue,
    FORMAT(
        SUM(Total_Price) / SUM(SUM(Total_Price)) OVER (),
        'P2'
    ) AS Contribution_Percentage
FROM sales_table
GROUP BY [Customer ID]
ORDER BY Customer_Revenue DESC;


--------------------------------------------------------------
-- 3.5 Customer Revenue Rank
--------------------------------------------------------------
SELECT
    [Customer ID],
    SUM(Total_Price) AS Customer_Revenue,
    RANK() OVER (ORDER BY SUM(Total_Price) DESC) AS Revenue_Rank
FROM sales_table
GROUP BY [Customer ID];


--------------------------------------------------------------
-- 3.6 Customer Revenue Quartiles (NTILE)
--------------------------------------------------------------
SELECT
    [Customer ID],
    SUM(Total_Price) AS Customer_Revenue,
    NTILE(4) OVER (ORDER BY SUM(Total_Price) DESC) AS Revenue_Quartile
FROM sales_table
GROUP BY [Customer ID];


--------------------------------------------------------------
-- 3.7 Recency: Days since last purchase (per customer)
--------------------------------------------------------------
SELECT
    s.[Customer ID],
    DATEDIFF(day, MAX(s.InvoiceDate), m.Max_InvoiceDate) AS Recency_Days
FROM sales_table s
CROSS JOIN (
    SELECT MAX(InvoiceDate) AS Max_InvoiceDate
    FROM sales_table
) m
GROUP BY
    s.[Customer ID],
    m.Max_InvoiceDate;


--------------------------------------------------------------
-- 3.8 Frequency & Monetary (RFM components)
--------------------------------------------------------------
SELECT
    s.[Customer ID],
    DATEDIFF(day, MAX(s.InvoiceDate), m.Max_InvoiceDate) AS Recency_Days,
    COUNT(DISTINCT Invoice) AS Frequency,
    SUM(Total_Price)        AS Monetary
FROM sales_table s
CROSS JOIN (
    SELECT MAX(InvoiceDate) AS Max_InvoiceDate
    FROM sales_table
) m
GROUP BY s.[Customer ID],m.Max_InvoiceDate



/*============================================================
  4) MONTHLY CUSTOMER REVENUE (View)
============================================================*/

-- Monthly revenue per customer
CREATE VIEW monthly_customer_revenue AS
SELECT
    [Customer ID],
    [Year],
    [Month],
    SUM(Total_Price) AS Monthly_Revenue
FROM sales_table
GROUP BY
    [Customer ID],
    [Year],
    [Month];

-- Top 10 (highest monthly revenue records)
SELECT TOP 10
    [Customer ID],
    [Year],
    [Month],
    Monthly_Revenue
FROM monthly_customer_revenue
ORDER BY Monthly_Revenue DESC;


/*============================================================
  5) PRODUCT ANALYSIS
============================================================*/

--------------------------------------------------------------
-- 5.1 Top 10 Products by Revenue
--------------------------------------------------------------
SELECT TOP 10
    Product,
    SUM(Total_Price) AS Product_Revenue
FROM sales_table
GROUP BY Product
ORDER BY Product_Revenue DESC;


--------------------------------------------------------------
-- 5.2 Top 10 Products by Quantity
--------------------------------------------------------------
SELECT TOP 10
    Product,
    SUM(Quantity) AS Total_Quantity
FROM sales_table
GROUP BY Product
ORDER BY Total_Quantity DESC;


--------------------------------------------------------------
-- 5.3 Top 10 Products by Invoice Count
--------------------------------------------------------------
SELECT TOP 10
    Product,
    COUNT(Invoice) AS Invoice_Count
FROM sales_table
GROUP BY Product
ORDER BY Invoice_Count DESC;


--------------------------------------------------------------
-- 5.4 Product Contribution to Total Sales (%)
--------------------------------------------------------------
SELECT
    Product,
    SUM(Total_Price) AS Product_Revenue,
    FORMAT(
        SUM(Total_Price) / SUM(SUM(Total_Price)) OVER (),
        'P2'
    ) AS Contribution_Percentage
FROM sales_table
GROUP BY Product
ORDER BY Product_Revenue DESC;


--------------------------------------------------------------
-- 5.5 Top 3 Products per Country by Revenue
--------------------------------------------------------------
SELECT *
FROM (
    SELECT
        Country,
        Product,
        SUM(Total_Price) AS Revenue,
        RANK() OVER (
            PARTITION BY Country
            ORDER BY SUM(Total_Price) DESC
        ) AS Rank_In_Country
    FROM sales_table
    GROUP BY
        Country,
        Product
) t
WHERE Rank_In_Country <= 3;




CREATE VIEW Married_Order AS
SELECT 
    sales_table.Invoice,
    COUNT(DISTINCT PRODUCT) AS n_distinct_products,
    CASE 
        WHEN COUNT(DISTINCT PRODUCT) > 1 THEN 'Married'
        ELSE 'Single'
    END AS Order_Type
FROM sales_table
GROUP BY sales_table.Invoice;