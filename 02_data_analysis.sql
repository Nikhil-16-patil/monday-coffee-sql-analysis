-- ================================================
-- MONDAY COFFEE — SQL DATA ANALYSIS PROJECT
-- Author: [Your Name]
-- Date: July 2026
-- Tools: MySQL 8.0+ (uses window functions & CTEs)
-- Dataset: 4 tables, 10,388 transactions
--          14 Indian cities, 497 customers, 28 products
-- ================================================

USE COFFEE;

-- ══════════════════════════════════════
-- 1. What is the total revenue generated?
-- ══════════════════════════════════════

SELECT 
    SUM(total) AS total_revenue
FROM coffee_detail;


-- ══════════════════════════════════════
-- 2. Which cities generate the most revenue?
-- ══════════════════════════════════════

SELECT 
    city_name,
    population,
    SUM(total) AS total_revenue
FROM coffee_detail
GROUP BY city_name, population
ORDER BY total_revenue DESC;


-- ══════════════════════════════════════
-- 3. What are the top 5 best-selling products?
-- ══════════════════════════════════════

SELECT 
    product_name,
    SUM(total) AS total_revenue
FROM coffee_detail
GROUP BY product_name
ORDER BY total_revenue DESC
LIMIT 5;


-- ══════════════════════════════════════
-- 4. What is the monthly revenue trend?
-- ══════════════════════════════════════

SELECT 
    YEAR(sale_date) AS year,
    MONTH(sale_date) AS months,
    SUM(total) AS total_revenue
FROM coffee_detail
GROUP BY year, months
ORDER BY year, months;


-- ══════════════════════════════════════
-- 5. Which products have the lowest ratings?
-- ══════════════════════════════════════

SELECT 
    product_name,
    ROUND(AVG(rating), 2) AS avg_rating
FROM coffee_detail
GROUP BY product_name
ORDER BY avg_rating;


-- ══════════════════════════════════════
-- 6. Which customers have never made a purchase?
-- ══════════════════════════════════════
-- Note: coffee_detail is built with INNER JOINs, so a customer
-- with zero sales would never appear in it at all. We must go
-- back to the original customers/sales tables with a LEFT JOIN.

SELECT 
    c.customer_name,
    s.sale_id,
    s.customer_id,
    s.total
FROM customers c
LEFT JOIN sales s
    ON s.customer_id = c.customer_id
WHERE s.sale_id IS NULL;

-- Result: 0 rows — all 497 customers have made at least one purchase.


-- ══════════════════════════════════════
-- 7. What is the month-over-month revenue change?
-- ══════════════════════════════════════

WITH Monthly_revenue AS 
(
    SELECT 
        YEAR(sale_date) AS year,
        MONTH(sale_date) AS month,
        SUM(total) AS total_revenue
    FROM coffee_detail
    GROUP BY year, month
),
with_lag AS 
(
    SELECT 
        *,
        LAG(total_revenue) OVER (ORDER BY year, month) AS previous_month_revenue
    FROM Monthly_revenue
)
SELECT 
    year,
    month,
    total_revenue,
    previous_month_revenue,
    (total_revenue - previous_month_revenue) AS revenue_change,
    ROUND((total_revenue - previous_month_revenue) / previous_month_revenue * 100, 2) AS pct_change
FROM with_lag
ORDER BY year, month;


-- ══════════════════════════════════════
-- 8. What are the top 3 products per city?
-- ══════════════════════════════════════

SELECT * 
FROM (
    SELECT 
        city_name,
        product_name,
        SUM(total) AS total_revenue,
        RANK() OVER (PARTITION BY city_name ORDER BY SUM(total) DESC) AS ranks
    FROM coffee_detail
    GROUP BY product_name, city_name
) AS Ranked
WHERE ranks <= 3
ORDER BY city_name, ranks;


-- ══════════════════════════════════════
-- 9. What does the running revenue total look like?
-- ══════════════════════════════════════

WITH monthly_revenue AS 
(
    SELECT 
        YEAR(sale_date) AS year,
        MONTH(sale_date) AS month,
        SUM(total) AS total_revenue
    FROM coffee_detail
    GROUP BY year, month
),
running_total AS 
(
    SELECT 
        *,
        SUM(total_revenue) OVER (ORDER BY year, month) AS Running
    FROM monthly_revenue
)
SELECT * FROM running_total;


-- ══════════════════════════════════════
-- 10. How can customers be segmented by purchase behavior?
-- ══════════════════════════════════════

SELECT 
    customer_id,
    customer_name,
    COUNT(DISTINCT sale_id) AS total_orders,
    SUM(total) AS total_spend,
    ROUND(AVG(total), 2) AS avg_order_value,
    CASE 
        WHEN SUM(total) >= 18000 THEN 'High Value'
        WHEN SUM(total) >= 6500 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS spend_segment,
    CASE 
        WHEN COUNT(DISTINCT sale_id) >= 20 THEN 'Frequent Buyer'
        WHEN COUNT(DISTINCT sale_id) >= 10 THEN 'Occasional Buyer'
        ELSE 'Rare Buyer'
    END AS frequency_segment
FROM coffee_detail
GROUP BY customer_id, customer_name
ORDER BY total_spend DESC;


-- ══════════════════════════════════════
-- 11. Which cities are best for expansion (revenue vs rent)?
-- ══════════════════════════════════════
-- Note: estimated_rent is a monthly figure, while total_revenue is
-- cumulative across ~22 months. A revenue-to-rent RATIO is a more
-- meaningful efficiency metric here than a simple subtraction.

SELECT 
    city_name,
    estimated_rent,
    SUM(total) AS Total_revenue,
    ROUND(SUM(total) / estimated_rent, 2) AS revenue_to_rent_ratio
FROM coffee_detail
GROUP BY city_name, estimated_rent
ORDER BY revenue_to_rent_ratio DESC;


-- ══════════════════════════════════════
-- 12. What is the best month for each product?
-- ══════════════════════════════════════

WITH Month_Revenue AS 
(
    SELECT 
        MONTH(sale_date) AS month,
        product_name,
        SUM(total) AS total_revenue
    FROM coffee_detail
    GROUP BY product_name, month
),
ranked_months AS 
(
    SELECT
        *,
        DENSE_RANK() OVER (PARTITION BY product_name ORDER BY total_revenue DESC) AS ranks
    FROM Month_Revenue
)
SELECT 
    product_name,
    month,
    total_revenue
FROM ranked_months
WHERE ranks = 1
ORDER BY product_name;


-- ══════════════════════════════════════
-- 13. How many customers returned in 2024 vs 2023?
-- ══════════════════════════════════════

SELECT 
    COUNT(DISTINCT CASE WHEN YEAR(sale_date) = 2023 THEN customer_id END) AS customers_2023,
    COUNT(DISTINCT CASE WHEN YEAR(sale_date) = 2024 THEN customer_id END) AS customers_2024,
    COUNT(DISTINCT CASE 
        WHEN customer_id IN (
            SELECT customer_id FROM coffee_detail WHERE YEAR(sale_date) = 2023
        ) AND customer_id IN (
            SELECT customer_id FROM coffee_detail WHERE YEAR(sale_date) = 2024
        ) THEN customer_id 
    END) AS returning_customers
FROM coffee_detail;


-- ══════════════════════════════════════
-- 14. What is the average revenue per customer per city?
-- ══════════════════════════════════════

SELECT 
    city_name,
    ROUND(SUM(total) / COUNT(DISTINCT customer_id), 2) AS Avg_revenue_per_customer
FROM coffee_detail
GROUP BY city_name
ORDER BY avg_revenue_per_customer DESC;


-- ══════════════════════════════════════
-- 15. How did 2023 compare to 2024?
-- ══════════════════════════════════════
-- Note: 2024 only has 10 months of data (Jan–Oct) vs a full 12
-- months in 2023, so raw totals aren't directly comparable —
-- see README for a normalized monthly comparison.

SELECT 
    YEAR(sale_date) AS year,
    COUNT(sale_id) AS total_orders,
    COUNT(DISTINCT customer_id) AS unique_customers,
    SUM(total) AS total_revenue,
    ROUND(AVG(total), 2) AS avg_order_value,
    ROUND(AVG(rating), 2) AS avg_order_rating
FROM coffee_detail
GROUP BY year
ORDER BY year;
