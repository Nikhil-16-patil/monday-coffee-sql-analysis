# ☕ Monday Coffee — SQL Data Analysis Project

## Project Overview
Monday Coffee is an Indian coffee brand selling products across
14 cities. This project analyzes 10,388 transactions from
January 2023 to October 2024 to identify top-performing cities,
products, and customers — and recommend expansion strategy.

## Business Questions Answered
1. What is the total revenue generated?
2. Which cities generate the most revenue?
3. What are the top 5 best-selling products?
4. What is the monthly revenue trend?
5. Which products have the lowest ratings?
6. Which customers have never made a purchase?
7. What is the month-over-month revenue change?
8. What are the top 3 products per city?
9. What does the running revenue total look like?
10. How can customers be segmented by purchase behavior?
11. Which cities are best for expansion (revenue vs rent)?
12. What is the best month for each product?
13. How many customers returned in 2024 vs 2023?
14. What is the average revenue per customer per city?
15. How did 2023 compare to 2024?

## Dataset
| Table | Rows | Description |
|-------|------|-------------|
| city | 14 | Indian cities with population and rent data |
| customers | 497 | Customer details with city mapping |
| products | 28 | Coffee products with prices (₹200–₹1,800) |
| sales | 10,388 | Transaction records with ratings |

## Key Findings
- Total Revenue: ₹60,70,190
- Average Rating: 3.99/5
- Date Range: Jan 2023 – Oct 2024
- Top City: [update after analysis]
- Best Product: [update after analysis]

## Tools Used
- MySQL — data cleaning, transformation, analysis
- Tableau Public — dashboard visualization
- GitHub — version control and portfolio

## Project Structure
monday-coffee-sql-analysis/
├── data/               ← raw CSV files
├── sql/
│   ├── 01_data_preparation.sql
│   └── 02_analysis_queries.sql
└── images/
    └── dashboard.png

## How to Run
1. Import all 4 CSV files into MySQL as separate tables
2. Run sql/01_data_preparation.sql to create master table
3. Run sql/02_analysis_queries.sql for business insights

## Author
[Your Name] | [LinkedIn URL] | [Tableau Public URL]
