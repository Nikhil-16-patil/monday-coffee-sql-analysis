-- ================================================
-- MONDAY COFFEE — SQL DATA ANALYSIS PROJECT
-- Author: [Your Name]
-- Date: July 2026
-- Tools: MySQL
-- Dataset: 4 tables, 10,388 transactions
--          14 Indian cities, 497 customers, 28 products
-- ================================================

USE COFFEE;

-- ══════════════════════════════════════
-- PHASE 1: EXPLORE RAW DATA
-- ══════════════════════════════════════

SELECT * FROM city;
SELECT * FROM products;

-- Check for hidden spaces in price column
SELECT TRIM(price), price FROM products;

-- ══════════════════════════════════════
-- PHASE 2: TEST JOIN LOGIC
-- ══════════════════════════════════════

SELECT
    cu.customer_id,
    cu.customer_name,
    c.city_id,
    c.city_name,
    c.population,
    c.estimated_rent,
    c.city_rank,
    s.sale_id,
    s.sale_date,
    s.product_id,
    s.total,
    s.rating,
    p.product_name,
    p.price
FROM city c
JOIN customers cu ON c.city_id = cu.city_id
JOIN sales s ON s.customer_id = cu.customer_id
JOIN products p ON p.product_id = s.product_id;

-- ══════════════════════════════════════
-- PHASE 3: CREATE MASTER TABLE
-- ══════════════════════════════════════

CREATE TABLE coffee_detail AS
SELECT
    cu.customer_id,
    cu.customer_name,
    c.city_id,
    c.city_name,
    c.population,
    c.estimated_rent,
    c.city_rank,
    s.sale_id,
    s.sale_date,
    s.product_id,
    s.total,
    s.rating,
    p.product_name,
    p.price
FROM city c
JOIN customers cu ON c.city_id = cu.city_id
JOIN sales s ON s.customer_id = cu.customer_id
JOIN products p ON p.product_id = s.product_id;

-- ══════════════════════════════════════
-- PHASE 4: VERIFY ROW COUNT
-- ══════════════════════════════════════

-- Total rows in master table
SELECT COUNT(*) AS total_rows FROM coffee_detail;

-- Cross-check against source table
SELECT COUNT(*) AS coffee_detail_rows FROM coffee_detail
UNION ALL
SELECT COUNT(*) AS sales_rows FROM sales;

-- ══════════════════════════════════════
-- PHASE 5: FIX DATA TYPES
-- ══════════════════════════════════════

-- Check current column types
DESCRIBE coffee_detail;

-- Fix sale_date from TEXT to DATE
UPDATE coffee_detail
SET sale_date = STR_TO_DATE(sale_date, '%Y-%m-%d');

ALTER TABLE coffee_detail
MODIFY COLUMN sale_date DATE;

-- ══════════════════════════════════════
-- PHASE 6: VERIFY DATE FIX
-- ══════════════════════════════════════

SELECT
    sale_date,
    YEAR(sale_date)  AS year,
    MONTH(sale_date) AS month,
    DAY(sale_date)   AS day
FROM coffee_detail
LIMIT 10;

SELECT
    MIN(sale_date) AS earliest_sale,
    MAX(sale_date) AS latest_sale,
    COUNT(DISTINCT sale_date) AS unique_dates
FROM coffee_detail;

-- ══════════════════════════════════════
-- PHASE 7: NULL CHECK — ALL 14 COLUMNS
-- ══════════════════════════════════════

SELECT
    SUM(CASE WHEN customer_id    IS NULL THEN 1 ELSE 0 END) AS null_customer_id,
    SUM(CASE WHEN customer_name  IS NULL THEN 1 ELSE 0 END) AS null_customer_name,
    SUM(CASE WHEN city_id        IS NULL THEN 1 ELSE 0 END) AS null_city_id,
    SUM(CASE WHEN city_name      IS NULL THEN 1 ELSE 0 END) AS null_city_name,
    SUM(CASE WHEN population     IS NULL THEN 1 ELSE 0 END) AS null_population,
    SUM(CASE WHEN estimated_rent IS NULL THEN 1 ELSE 0 END) AS null_estimated_rent,
    SUM(CASE WHEN city_rank      IS NULL THEN 1 ELSE 0 END) AS null_city_rank,
    SUM(CASE WHEN sale_id        IS NULL THEN 1 ELSE 0 END) AS null_sale_id,
    SUM(CASE WHEN sale_date      IS NULL THEN 1 ELSE 0 END) AS null_sale_date,
    SUM(CASE WHEN product_id     IS NULL THEN 1 ELSE 0 END) AS null_product_id,
    SUM(CASE WHEN total          IS NULL THEN 1 ELSE 0 END) AS null_total,
    SUM(CASE WHEN rating         IS NULL THEN 1 ELSE 0 END) AS null_rating,
    SUM(CASE WHEN product_name   IS NULL THEN 1 ELSE 0 END) AS null_product_name,
    SUM(CASE WHEN price          IS NULL THEN 1 ELSE 0 END) AS null_price
FROM coffee_detail;

-- ══════════════════════════════════════
-- PHASE 8: DUPLICATE CHECK
-- ══════════════════════════════════════

SELECT sale_id, COUNT(*) AS count
FROM coffee_detail
GROUP BY sale_id
HAVING COUNT(*) > 1;
-- Expected: empty result (no duplicates)

-- ══════════════════════════════════════
-- PHASE 9: TRIM CHECK
-- ══════════════════════════════════════

SELECT
    TRIM(city_name),
    TRIM(product_name),
    TRIM(customer_name)
FROM coffee_detail
LIMIT 10;

-- ══════════════════════════════════════
-- FINAL SUMMARY STATS
-- ══════════════════════════════════════

SELECT
    COUNT(*)                            AS total_transactions,
    COUNT(DISTINCT customer_id)         AS unique_customers,
    COUNT(DISTINCT city_id)             AS unique_cities,
    COUNT(DISTINCT product_id)          AS unique_products,
    MIN(sale_date)                      AS date_from,
    MAX(sale_date)                      AS date_to,
    SUM(total)                          AS total_revenue,
    ROUND(AVG(rating), 2)              AS avg_rating
FROM coffee_detail;