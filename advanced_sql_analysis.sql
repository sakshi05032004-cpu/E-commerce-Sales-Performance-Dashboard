use ecommercedb;


-- View Dataset
SELECT * FROM sales;

-- Total Revenue
SELECT
SUM(Quantity * 'Unit Price') AS Total_Revenue
FROM sales;

-- Total Profit
SELECT
SUM(Profit) AS Total_Profit
FROM sales;

-- Total Orders
SELECT
COUNT(DISTINCT 'Order ID') AS Total_Orders
FROM sales;

-- Total Customers
SELECT
COUNT(DISTINCT 'Customer ID') AS Total_Customers
FROM sales;

-- Average Order Value
SELECT
SUM(Quantity * 'Unit Price') /
COUNT(DISTINCT 'Order ID') AS Average_Order_Value
FROM sales;

-- Average Profit
SELECT
AVG(Profit) AS Average_Profit
FROM sales;

-- Profit Margin
SELECT
ROUND(
(SUM(Profit) / SUM(Quantity * 'Unit Price')) * 100,
2
) AS Profit_Margin
FROM sales;

-- Sales by Category
SELECT
Category,
SUM(Quantity * 'Unit Price') AS Revenue
FROM sales
GROUP BY Category
ORDER BY Revenue DESC;

-- Profit by Category
SELECT
Category,
SUM(Profit) AS Profit
FROM sales
GROUP BY Category
ORDER BY Profit DESC;

-- Sales by Region
SELECT
Region,
SUM(Quantity * 'Unit Price') AS Revenue
FROM sales
GROUP BY Region
ORDER BY Revenue DESC;

-- Sales by State
SELECT
State,
SUM(Quantity * 'Unit Price') AS Revenue
FROM sales
GROUP BY State
ORDER BY Revenue DESC;

-- Monthly Sales
SELECT
MONTH('Order Date') AS Month,
SUM(Quantity * 'Unit Price') AS Revenue
FROM sales
GROUP BY MONTH('Order Date')
ORDER BY Month;

-- Yearly Sales
SELECT
YEAR('Order Date') AS Year,
SUM(Quantity * 'Unit Price') AS Revenue
FROM sales
GROUP BY YEAR('Order Date')
ORDER BY Year;

-- Quarterly Sales
SELECT
QUARTER('Order Date') AS Quarter,
SUM(Quantity * 'Unit Price') AS Revenue
FROM sales
GROUP BY QUARTER('Order Date')
ORDER BY Quarter;

-- Top 10 Products
SELECT
'Product Name',
SUM(Quantity * 'Unit Price') AS Revenue
FROM sales
GROUP BY 'Product Name'
ORDER BY Revenue DESC
LIMIT 10;

-- Top 10 Customers
SELECT
'Customer Name',
SUM(Quantity * 'Unit Price') AS Revenue
FROM sales
GROUP BY 'Customer Name'
ORDER BY Revenue DESC
LIMIT 10;

-- Highest Profit Products
SELECT
'Product Name',
SUM(Profit) AS 'Total Profit'
FROM sales
GROUP BY 'Product Name'
ORDER BY 'Total Profit' DESC
LIMIT 10;

-- Quantity Sold by Product
SELECT
'Product Name',
SUM(Quantity) AS 'Quantity Sold'
FROM sales
GROUP BY 'Product Name'
ORDER BY 'Quantity Sold' DESC;

-- Payment Mode Analysis
SELECT
'Payment Mode',
SUM(Quantity * 'Unit Price') AS Revenue
FROM sales
GROUP BY 'Payment Mode'
ORDER BY Revenue DESC;

-- Customer Purchase Frequency
SELECT
'Customer ID',
COUNT('Order ID') AS Total_Orders
FROM sales
GROUP BY 'Customer ID'
ORDER BY Total_Orders DESC;

-- Customers with Revenue Greater Than 100000
SELECT
'Customer Name',
SUM(Quantity * 'Unit Price') AS Revenue
FROM sales
GROUP BY 'Customer Name'
HAVING Revenue > 100000;

-- Revenue by Category and Region
SELECT
Category,
Region,
SUM(Quantity * 'Unit Price') AS Revenue
FROM sales
GROUP BY Category, Region
ORDER BY Revenue DESC;

-- Best Selling Category
SELECT
Category,
SUM(Quantity) AS Quantity_Sold
FROM sales
GROUP BY Category
ORDER BY Quantity_Sold DESC
LIMIT 1;

-- Rank Products by Revenue
SELECT
'Product Name',
SUM(Quantity * 'Unit Price') AS Revenue,
RANK() OVER(
ORDER BY SUM(Quantity * 'Unit Price') DESC
) AS Product_Rank
FROM sales
GROUP BY 'Product Name';

-- Top 5 Customers Using ROW_NUMBER()
SELECT *
FROM
(
SELECT
'Customer Name',
SUM(Quantity * 'Unit Price') AS Revenue,
ROW_NUMBER() OVER(
ORDER BY SUM(Quantity * 'Unit Price') DESC
) AS rn
FROM sales
GROUP BY 'Customer Name'
) AS CustomerRank
WHERE rn <= 5;

-- Dashboard KPI Query
SELECT
SUM(Quantity * 'Unit Price') AS Total_Revenue,
SUM(Profit) AS Total_Profit,
COUNT(DISTINCT 'Order ID') AS Total_Orders,
COUNT(DISTINCT 'Customer ID') AS Total_Customers,
ROUND(
SUM(Quantity * 'Unit Price') /
COUNT(DISTINCT 'Order ID'),
2
) AS Average_Order_Value,
ROUND(
SUM(Profit) /
SUM(Quantity * 'Unit Price') * 100,
2
) AS Profit_Margin
FROM sales;
