# Advanced SQL Business Analytics

A collection of **advanced SQL queries designed for real-world business analytics scenarios.**

The repository demonstrates how SQL can be used to extract insights from relational databases such as:

- Customer purchasing behavior
- Supplier performance metrics
- Inventory monitoring
- Employee organizational structure
- Financial transactions
- Sales analytics

These queries simulate analytics tasks typically performed in **data analyst, data engineering, and BI roles.**

---

# Project Overview

This project contains SQL queries designed to analyze data from a typical business database containing entities such as:

Customers  
Orders  
Products  
Suppliers  
Transactions  
Departments  
Employees  
Inventory  

The goal is to demonstrate **advanced SQL techniques used for analytical reporting and operational insights.**

---

# Key Concepts Demonstrated

The queries use several advanced SQL techniques including:

• Subqueries  
• Aggregations (SUM, AVG, COUNT, MAX, MIN)  
• Window functions  
• CASE statements  
• Date calculations  
• Multi-table joins  
• Business metric calculations  

---

# Example Analytics Tasks

## Customer Purchase Analysis

Calculates metrics such as:

- Total spending per customer
- Average order value
- Days since last order
- Number of unique products purchased

Example metrics returned:


CustomerID
TotalAmountSpent
TotalOrders
AvgOrderAmount
DaysSinceLastOrder
UniqueProductsOrdered


---

## Supplier Performance Ranking

Evaluates supplier business performance including:

- Total revenue generated
- Total products sold
- Average revenue per product
- Customer reach
- Revenue contribution percentage

Suppliers are ranked using:


ROW_NUMBER() OVER (ORDER BY TotalRevenue DESC)


This allows identification of **top performing suppliers.**

---

## Inventory Status Monitoring

Determines whether each product is currently in stock.

Example logic:


CASE
WHEN QuantityOnHand > 0 THEN 'In Stock'
ELSE 'Not In Stock'
END


This type of query is useful for **inventory dashboards and ERP systems.**

---

## Employee Organizational Hierarchy

Shows employees along with their department and manager information.

Example output fields:

- Employee Name
- Position
- Department
- Manager Name

This demonstrates **hierarchical relationships inside SQL databases.**

---

## Financial Transaction Analysis

Calculates metrics such as:

- Total transaction amount per supplier
- Average transaction value
- Number of unpaid transactions
- Latest transaction date

This helps monitor **financial activity and supplier payment status.**

---

# Example Query Categories

The repository contains queries that answer questions like:

• Which customers spend more than the average order value?  
• Which suppliers generate the highest revenue?  
• Which products are currently in stock?  
• Who manages each employee?  
• What is the purchasing behavior of customers?  
• Which suppliers contribute the most revenue?  

---

# Technologies Used

SQL Server  
T-SQL  
Relational Databases  
Data Analytics  

---

# File Structure


advanced-sql-business-analytics
│
├── SQLQuery_1.sql
├── SQLQuery_2.sql
└── README.md


---

# Skills Demonstrated

SQL Query Design  
Business Intelligence Analytics  
Data Aggregation & Metrics  
Database Joins & Subqueries  
Financial Data Analysis  

---

# Author

Tomer Biton

AI & Data Systems Builder  
Building automation platforms, data pipelines, and AI insight systems.

Tel Aviv, Israel
