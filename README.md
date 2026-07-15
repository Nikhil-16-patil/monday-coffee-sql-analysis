☕ Monday Coffee — SQL Data Analysis Project

Project Overview

Monday Coffee is an Indian coffee brand selling products across 14 cities.
This project analyzes 10,388 transactions from January 2023 to October 2024
to identify top-performing cities, products, and customers — and recommend
an expansion strategy based on revenue efficiency.

Business Questions Answered


What is the total revenue generated?
Which cities generate the most revenue?
What are the top 5 best-selling products?
What is the monthly revenue trend?
Which products have the lowest ratings?
Which customers have never made a purchase?
What is the month-over-month revenue change?
What are the top 3 products per city?
What does the running revenue total look like?
How can customers be segmented by purchase behavior?
Which cities are best for expansion (revenue vs. rent)?
What is the best month for each product?
How many customers returned in 2024 vs. 2023?
What is the average revenue per customer per city?
How did 2023 compare to 2024?


Dataset

TableRowsDescriptioncity14Indian cities with population and estimated rentcustomers497Customer details with city mappingproducts28Coffee products with prices (₹200–₹1,800)sales10,388Transaction records with ratings

Key Findings


Total Revenue: ₹60,70,190
Average Rating: 3.99 / 5
Date Range: Jan 2023 – Oct 2024
Top City by Revenue: Pune (₹12,58,290)
Best-Selling Product: Cold Brew Coffee Pack (6 Bottles) (₹11,93,400)
Customer Retention: 494 of 496 customers (99.6%) who purchased in 2023
returned in 2024
Best Expansion Targets: Pune and Jaipur have the highest revenue-to-rent
ratios (82.2x and 74.4x), making them the most cost-efficient markets for
further investment — while Hyderabad and Mumbai have the lowest (5.9x and
7.5x) despite solid total revenue
Seasonality: Revenue nearly triples between September and November 2023,
staying elevated through March 2024, before returning to baseline — a
seasonal spike rather than sustained growth


Tools Used


MySQL — data cleaning, transformation, and analysis
GitHub — version control and portfolio


Project Structure

monday-coffee-sql-analysis/
├── city.csv
├── customers.csv
├── products.csv
├── sales.csv
├── 01_data_preparation.sql
├── 02_data_analysis.sql
└── README.md

How to Run


Import all 4 CSV files into MySQL as separate tables (city, customers,
products, sales).
Run 01_data_preparation.sql to build and clean the master
coffee_detail table (joins, data type fixes, null/duplicate checks).
Run 02_data_analysis.sql to answer all 15 business questions.
