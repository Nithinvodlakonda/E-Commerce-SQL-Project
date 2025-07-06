# 🛒 SQL E-Commerce Analytics Project

This project is part of My Practical Experience in SQL for Data Roles  
It simulates a real-world e-commerce business scenario and focuses on deriving **actionable insights** from customer, order, product, and payment data using **advanced SQL techniques**.

---

## 📂 Project Overview

- **Database:** Normalized e-commerce schema (customers, orders, products, payments, order_items)
- **Language:** SQL (compatible with MySQL / PostgreSQL)
- **Focus Areas:** Customer behavior, product sales, revenue trends, operational checks

---

## 🔍 Key Insights & Questions Answered

### 🧑‍💼 PART 1: Customer Insights
- How many new customers joined each month?
- Which cities have the most customers?
- Who are the top 5 spenders?
- Which customers placed more than one order?
- Who hasn't placed any orders?

### 📦 PART 2: Order Analysis
- Total orders placed in the last 2 years
- Average Order Value (AOV)
- Most active days of the week
- Order cancellation rate
- Late payments (paid after 5+ days)

### 🛍️ PART 3: Product Analysis
- Top-selling categories by revenue
- 10 most ordered products
- Products ordered but not paid
- Products never ordered
- Average price per category

### 💰 PART 4: Revenue & Sales Insights
- Monthly revenue for the last year
- 3 highest revenue-generating months
- Total revenue by city
- Monthly revenue growth rate (using window functions)
- % of revenue from returning customers

### 🛠️ PART 5: Operational / ETL-Type Checks
- Orders with missing or null payment details
- Duplicate customers (same name, different email)
- Products with price = 0 or NULL
- Orders containing quantity = 0
- Unique products ordered by each customer

---

## ⚙️ Tools Used
- **SQL**: Joins, GROUP BY, CTEs, CASE, `LAG()`, `ROUND()`, `NULLIF()`, `DATE_FORMAT()`
- **Database**: Structured sample tables (`customers`, `orders`, `products`, `order_items`, `payments`)

---

## 📁 Files Included
- `sql_e_commerce_tables.sql` – Table creation + sample data
- `sql_e_commerce_project.sql` – All analysis queries
---

## 📈 Future Enhancements
- Visualize insights using Power BI or Streamlit
- Add customer segmentation (RFM, cohort analysis)
- Build a reporting dashboard or automate weekly insights

---

## 🙋‍♂️ About Me

Hi, I’m Nithin — a B.Sc. Computer Science student passionate about Data Roles and solving business problems using SQL and data tools.

This is one of the many projects I’m working on as part of my analytics journey. Stay tuned for more!

---


