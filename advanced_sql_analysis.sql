-- =====================================================================
-- advanced_sql_analysis.sql
--
-- Run against ecommerce.db (build it first with setup_database.py).
--   sqlite3 ecommerce.db
--   .read advanced_sql_analysis.sql
--
-- Schema:
--   customers(customer_id, first_purchase_date)
--   products(product_id, product_name, product_category)
--   orders(order_id, order_date, customer_id, product_id, quantity_sold,
--          unit_price, discount_applied, payment_method, total_sales)
--
-- Each section below maps to a resume/interview talking point:
--   1. Joins
--   2. CTEs
--   3. Window functions (RANK, DENSE_RANK, LAG, LEAD)
--   4. Customer segmentation
--   5. Views
-- =====================================================================


-- ---------------------------------------------------------------------
-- 1. JOINS
-- Full order detail: combine the orders fact table with both dimension
-- tables so every row is human-readable (product name/category, and
-- each customer's first purchase date for tenure context).
-- ---------------------------------------------------------------------
SELECT
    o.order_id,
    o.order_date,
    c.customer_id,
    c.first_purchase_date,
    p.product_name,
    p.product_category,
    o.quantity_sold,
    o.unit_price,
    o.discount_applied,
    o.payment_method,
    o.total_sales
FROM orders AS o
INNER JOIN customers AS c ON o.customer_id = c.customer_id
INNER JOIN products  AS p ON o.product_id  = p.product_id
ORDER BY o.order_date
LIMIT 20;


-- ---------------------------------------------------------------------
-- 2. CTEs
-- Break a multi-step calculation into named, readable stages:
-- monthly revenue per category, then each category's share of that
-- month's total revenue.
-- ---------------------------------------------------------------------
WITH monthly_category_revenue AS (
    SELECT
        strftime('%Y-%m', o.order_date) AS sales_month,
        p.product_category,
        SUM(o.total_sales) AS category_revenue
    FROM orders AS o
    JOIN products AS p ON o.product_id = p.product_id
    GROUP BY sales_month, p.product_category
),
monthly_total_revenue AS (
    SELECT sales_month, SUM(category_revenue) AS total_revenue
    FROM monthly_category_revenue
    GROUP BY sales_month
)
SELECT
    m.sales_month,
    m.product_category,
    ROUND(m.category_revenue, 2)                                  AS category_revenue,
    ROUND(100.0 * m.category_revenue / t.total_revenue, 1)        AS pct_of_month_revenue
FROM monthly_category_revenue AS m
JOIN monthly_total_revenue AS t ON m.sales_month = t.sales_month
ORDER BY m.sales_month, category_revenue DESC;


-- ---------------------------------------------------------------------
-- 3. WINDOW FUNCTIONS
-- (a) RANK / DENSE_RANK: rank customers by total spend without
--     collapsing them into a GROUP BY-only summary (row-level detail
--     is preserved, and both ranking styles are shown side by side so
--     the tie-handling difference is visible).
-- (b) LAG / LEAD: month-over-month revenue change.
-- ---------------------------------------------------------------------

-- (a) Customer ranking by lifetime spend
SELECT
    c.customer_id,
    ROUND(SUM(o.total_sales), 2) AS lifetime_spend,
    RANK()       OVER (ORDER BY SUM(o.total_sales) DESC) AS spend_rank,
    DENSE_RANK() OVER (ORDER BY SUM(o.total_sales) DESC) AS spend_dense_rank
FROM orders AS o
JOIN customers AS c ON o.customer_id = c.customer_id
GROUP BY c.customer_id
ORDER BY lifetime_spend DESC
LIMIT 15;

-- (b) Month-over-month revenue change
WITH monthly_revenue AS (
    SELECT
        strftime('%Y-%m', order_date) AS sales_month,
        SUM(total_sales) AS revenue
    FROM orders
    GROUP BY sales_month
)
SELECT
    sales_month,
    ROUND(revenue, 2) AS revenue,
    ROUND(LAG(revenue)  OVER (ORDER BY sales_month), 2) AS prev_month_revenue,
    ROUND(LEAD(revenue) OVER (ORDER BY sales_month), 2) AS next_month_revenue,
    ROUND(revenue - LAG(revenue) OVER (ORDER BY sales_month), 2) AS mom_change
FROM monthly_revenue
ORDER BY sales_month;


-- ---------------------------------------------------------------------
-- 4. CUSTOMER SEGMENTATION
-- Split customers into High / Medium / Low value tiers using NTILE,
-- then summarize each tier. This is the query behind the dashboard's
-- "Customer Segmentation" panel.
-- ---------------------------------------------------------------------
WITH customer_spend AS (
    SELECT
        customer_id,
        SUM(total_sales) AS lifetime_spend
    FROM orders
    GROUP BY customer_id
),
customer_tiers AS (
    SELECT
        customer_id,
        lifetime_spend,
        NTILE(3) OVER (ORDER BY lifetime_spend DESC) AS spend_tile
    FROM customer_spend
)
SELECT
    CASE spend_tile
        WHEN 1 THEN 'High-value'
        WHEN 2 THEN 'Medium-value'
        WHEN 3 THEN 'Low-value'
    END AS customer_segment,
    COUNT(*)                         AS num_customers,
    ROUND(AVG(lifetime_spend), 2)    AS avg_spend,
    ROUND(SUM(lifetime_spend), 2)    AS total_spend
FROM customer_tiers
GROUP BY spend_tile
ORDER BY spend_tile;


-- ---------------------------------------------------------------------
-- 5. VIEW
-- Persist the segmentation logic as a reusable view so BI tools
-- (or the Streamlit dashboard, via a SQL connection) can query
-- "current customer segment" without re-running the CTE each time.
-- ---------------------------------------------------------------------
DROP VIEW IF EXISTS customer_segments;

CREATE VIEW customer_segments AS
WITH customer_spend AS (
    SELECT customer_id, SUM(total_sales) AS lifetime_spend
    FROM orders
    GROUP BY customer_id
)
SELECT
    customer_id,
    lifetime_spend,
    CASE NTILE(3) OVER (ORDER BY lifetime_spend DESC)
        WHEN 1 THEN 'High-value'
        WHEN 2 THEN 'Medium-value'
        WHEN 3 THEN 'Low-value'
    END AS segment
FROM customer_spend;

-- Example usage of the view:
SELECT segment, COUNT(*) AS num_customers, ROUND(AVG(lifetime_spend), 2) AS avg_spend
FROM customer_segments
GROUP BY segment
ORDER BY avg_spend DESC;
