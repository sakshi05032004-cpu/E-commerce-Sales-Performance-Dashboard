# SQL ANALYSIS

# VIEW DATA
SELECT *
FROM ecommerce_sales;

# TOTAL REVENUE
SELECT
ROUND(SUM(Revenue), 2) AS Total_Revenue
FROM ecommerce_sales;

#TOTAL PROFIT
SELECT
ROUND(SUM(Profit), 2) AS Total_Profit
FROM ecommerce_sales;
#TOTAL ORDERS
SELECT
COUNT(DISTINCT Order_ID) AS Total_Orders
FROM ecommerce_sales;

#TOTAL CUSTOMERS
SELECT
COUNT(DISTINCT Customer_ID) AS Total_Customers
FROM ecommerce_sales;

#TOTAL QUANTITY SOLD
SELECT
SUM(Quantity) AS Total_Quantity_Sold
FROM ecommerce_sales;

#AVERAGE ORDER VALUE (AOV)
SELECT
ROUND(
SUM(Revenue) / COUNT(DISTINCT Order_ID),
2
) AS Average_Order_Value
FROM ecommerce_sales;

#OVERALL PROFIT MARGIN
SELECT
ROUND(
(SUM(Profit) / SUM(Revenue)) * 100,
2
) AS Profit_Margin_Percentage
FROM ecommerce_sales;


#MONTHLY SALES PERFORMANCE
SELECT
Year,
Month,
Month_Name,
ROUND(SUM(Revenue), 2) AS Monthly_Revenue,
ROUND(SUM(Profit), 2) AS Monthly_Profit,
COUNT(DISTINCT Order_ID) AS Total_Orders
FROM ecommerce_sales
GROUP BY
Year,
Month,
Month_Name
ORDER BY
Year,
Month;

#YEAR-WISE SALES
SELECT
Year,
ROUND(SUM(Revenue), 2) AS Revenue,
ROUND(SUM(Profit), 2) AS Profit,
COUNT(DISTINCT Order_ID) AS Orders
FROM ecommerce_sales
GROUP BY Year
ORDER BY Year;


#QUARTER-WISE PERFORMANCE
SELECT
Year,
Quarter,
ROUND(SUM(Revenue), 2) AS Revenue,
ROUND(SUM(Profit), 2) AS Profit,
COUNT(DISTINCT Order_ID) AS Orders
FROM ecommerce_sales
GROUP BY
Year,
Quarter
ORDER BY
Year,
Quarter;

#CATEGORY-WISE SALES
SELECT
Category,
ROUND(SUM(Revenue), 2) AS Revenue,
ROUND(SUM(Profit), 2) AS Profit,
SUM(Quantity) AS Quantity_Sold,
COUNT(DISTINCT Order_ID) AS Orders
FROM ecommerce_sales
GROUP BY Category
ORDER BY Revenue DESC;

#SUB-CATEGORY PERFORMANCE
SELECT
Category,
Sub_Category,
ROUND(SUM(Revenue), 2) AS Revenue,
ROUND(SUM(Profit), 2) AS Profit,
SUM(Quantity) AS Quantity_Sold
FROM ecommerce_sales
GROUP BY
Category,
Sub_Category
ORDER BY Revenue DESC;

#TOP 10 PRODUCTS BY REVENUE
SELECT
Product_ID,
Product_Name,
ROUND(SUM(Revenue), 2) AS Revenue,
ROUND(SUM(Profit), 2) AS Profit,
SUM(Quantity) AS Quantity_Sold
FROM ecommerce_sales
GROUP BY
Product_ID,
Product_Name
ORDER BY Revenue DESC
LIMIT 10;

#TOP 10 PRODUCTS BY PROFIT
SELECT
Product_ID,
Product_Name,
ROUND(SUM(Revenue), 2) AS Revenue,
ROUND(SUM(Profit), 2) AS Profit
FROM ecommerce_sales
GROUP BY
Product_ID,
Product_Name
ORDER BY Profit DESC
LIMIT 10;

#LOW-PROFIT / LOSS-MAKING PRODUCTS
SELECT
Product_ID,
Product_Name,
ROUND(SUM(Revenue), 2) AS Revenue,
ROUND(SUM(Profit), 2) AS Profit
FROM ecommerce_sales
GROUP BY
Product_ID,
Product_Name
HAVING SUM(Profit) <= 0
ORDER BY Profit ASC;


#REGION-WISE PERFORMANCE
SELECT
Region,
ROUND(SUM(Revenue), 2) AS Revenue,
ROUND(SUM(Profit), 2) AS Profit,
COUNT(DISTINCT Order_ID) AS Orders,
SUM(Quantity) AS Quantity_Sold
FROM ecommerce_sales
GROUP BY Region
ORDER BY Revenue DESC;

#STATE-WISE PERFORMANCE
SELECT
State,
ROUND(SUM(Revenue), 2) AS Revenue,
ROUND(SUM(Profit), 2) AS Profit,
COUNT(DISTINCT Order_ID) AS Orders
FROM ecommerce_sales
GROUP BY State
ORDER BY Revenue DESC;

#TOP 10 STATES BY REVENUE
SELECT
State,
ROUND(SUM(Revenue), 2) AS Revenue
FROM ecommerce_sales
GROUP BY State
ORDER BY Revenue DESC
LIMIT 10;

#CUSTOMER-WISE PERFORMANCE
SELECT
Customer_ID,
Customer_Name,
ROUND(SUM(Revenue), 2) AS Revenue,
ROUND(SUM(Profit), 2) AS Profit,
COUNT(DISTINCT Order_ID) AS Orders
FROM ecommerce_sales
GROUP BY
Customer_ID,
Customer_Name
ORDER BY Revenue DESC;

#TOP 10 CUSTOMERS
SELECT
Customer_ID,
Customer_Name,
ROUND(SUM(Revenue), 2) AS Revenue,
COUNT(DISTINCT Order_ID) AS Orders
FROM ecommerce_sales
GROUP BY
Customer_ID,
Customer_Name
ORDER BY Revenue DESC
LIMIT 10;

#CUSTOMER TYPE ANALYSIS
SELECT
Customer_Type,
COUNT(DISTINCT Customer_ID) AS Customers,
COUNT(DISTINCT Order_ID) AS Orders,
ROUND(SUM(Revenue), 2) AS Revenue,
ROUND(SUM(Profit), 2) AS Profit
FROM ecommerce_sales
GROUP BY Customer_Type
ORDER BY Revenue DESC;

#SEGMENT-WISE PERFORMANCE
SELECT
Segment,
COUNT(DISTINCT Customer_ID) AS Customers,
COUNT(DISTINCT Order_ID) AS Orders,
ROUND(SUM(Revenue), 2) AS Revenue,
ROUND(SUM(Profit), 2) AS Profit
FROM ecommerce_sales
GROUP BY Segment
ORDER BY Revenue DESC;

#SHIPPING MODE ANALYSIS
SELECT
Ship_Mode,
COUNT(DISTINCT Order_ID) AS Orders,
ROUND(SUM(Revenue), 2) AS Revenue,
ROUND(SUM(Profit), 2) AS Profit
FROM ecommerce_sales
GROUP BY Ship_Mode
ORDER BY Orders DESC;

#DISCOUNT VS PROFIT
SELECT
Discount,
ROUND(SUM(Revenue), 2) AS Revenue,
ROUND(SUM(Profit), 2) AS Profit,
COUNT(*) AS Transactions
FROM ecommerce_sales
GROUP BY Discount
ORDER BY Discount;

#PROFIT MARGIN BY CATEGORY
SELECT
Category,
ROUND(SUM(Revenue), 2) AS Revenue,
ROUND(SUM(Profit), 2) AS Profit,
ROUND(
(SUM(Profit) / NULLIF(SUM(Revenue), 0)) * 100,
2
) AS Profit_Margin
FROM ecommerce_sales
GROUP BY Category
ORDER BY Profit_Margin DESC;

#PROFIT MARGIN BY REGION
SELECT
Region,
ROUND(SUM(Revenue), 2) AS Revenue,
ROUND(SUM(Profit), 2) AS Profit,
ROUND(
(SUM(Profit) / NULLIF(SUM(Revenue), 0)) * 100,
2
) AS Profit_Margin
FROM ecommerce_sales
GROUP BY Region
ORDER BY Profit_Margin DESC;

#MONTH WITH HIGHEST REVENUE
SELECT
Year,
Month,
Month_Name,
ROUND(SUM(Revenue), 2) AS Revenue
FROM ecommerce_sales
GROUP BY
Year,
Month,
Month_Name
ORDER BY Revenue DESC
LIMIT 1;

#MONTH WITH HIGHEST PROFIT
SELECT
Year,
Month,
Month_Name,
ROUND(SUM(Profit), 2) AS Profit
FROM ecommerce_sales
GROUP BY
Year,
Month,
Month_Name
ORDER BY Profit DESC
LIMIT 1;

#CATEGORY CONTRIBUTION TO TOTAL REVENUE
SELECT
Category,
ROUND(SUM(Revenue), 2) AS Revenue,
ROUND(
SUM(Revenue) * 100.0 /
SUM(SUM(Revenue)) OVER (),
2
) AS Revenue_Contribution_Percentage
FROM ecommerce_sales
GROUP BY Category
ORDER BY Revenue DESC;

#REGION CONTRIBUTION TO TOTAL REVENUE
SELECT
Region,
ROUND(SUM(Revenue), 2) AS Revenue,
ROUND(
SUM(Revenue) * 100.0 /
SUM(SUM(Revenue)) OVER (),
2
) AS Revenue_Contribution_Percentage
FROM ecommerce_sales
GROUP BY Region
ORDER BY Revenue DESC;

#RANK PRODUCTS BY REVENUE
SELECT
Product_ID,
Product_Name,
ROUND(SUM(Revenue), 2) AS Revenue,

RANK() OVER (
    ORDER BY SUM(Revenue) DESC
) AS Revenue_Rank
FROM ecommerce_sales
GROUP BY
Product_ID,
Product_Name
ORDER BY Revenue_Rank;

#RANK CATEGORIES BY PROFIT
SELECT
Category,
ROUND(SUM(Profit), 2) AS Profit,
RANK() OVER (
    ORDER BY SUM(Profit) DESC
) AS Profit_Rank
FROM ecommerce_sales
GROUP BY Category
ORDER BY Profit_Rank;

#CUSTOMER RANKING
SELECT
Customer_ID,
Customer_Name,
ROUND(SUM(Revenue), 2) AS Revenue,
RANK() OVER (
    ORDER BY SUM(Revenue) DESC
) AS Customer_Rank
FROM ecommerce_sales
GROUP BY
Customer_ID,
Customer_Name
ORDER BY Customer_Rank;

#FINAL DASHBOARD KPI QUERY
SELECT
ROUND(SUM(Revenue), 2)
    AS Total_Revenue,
ROUND(SUM(Profit), 2)
    AS Total_Profit,
COUNT(DISTINCT Order_ID)
    AS Total_Orders,
COUNT(DISTINCT Customer_ID)
    AS Total_Customers,
SUM(Quantity)
    AS Total_Quantity_Sold,
ROUND(
    SUM(Revenue) /
    NULLIF(COUNT(DISTINCT Order_ID), 0),
    2
) AS Average_Order_Value,
ROUND(
    (SUM(Profit) /
    NULLIF(SUM(Revenue), 0)) * 100,
    2
) AS Profit_Margin
FROM ecommerce_sales;
