
# 📊 Glassdoor Job Postings Data Cleaning (SQL Project)

## 🧠 Project Overview

This project focuses on **cleaning and preparing raw job posting data from Glassdoor** using SQL. The dataset contains job listings for data science-related roles, including attributes such as salary estimates, company names, locations, industry, and more. The goal is to transform this unstructured, messy dataset into a clean and analysis-ready format.

## 🛠️ Skills Applied

- SQL Data Cleaning  
- Data Transformation  
- String Manipulation  
- NULL and Missing Data Handling  
- Window Functions  
- Column Splitting and Parsing

---

## 📌 Key Steps in the Project

1. **Removing Ratings from Company Names**  
   Extracted clean company names by stripping appended ratings (e.g., `"ABC Corp.3.4"` → `"ABC Corp"`).

2. **Removing Duplicates**  
   Used `ROW_NUMBER()` window function to identify and delete duplicate records based on job title, salary, company, and location.

3. **Handling NULL and Invalid Data**  
   Replaced placeholder values like `"-1"` and `"Unknown / Non-Applicable"` with `NULL` for fields like `Founded`, `Revenue`, and `Industry`.

4. **Salary Parsing**  
   Extracted salary values and created a new `formatted_salary_range` column to convert salary strings into numeric values. Also generated `Min_Salary` and `Max_Salary` columns.

5. **Location Breakdown**  
   Split the `Location` column into `Location_City` and `Location_State` for more detailed analysis.

6. **Dropping Redundant Columns**  
   Removed columns that were either cleaned or transformed to avoid duplication and improve data clarity.

7. **Industry Analysis**  
   Generated industry-wise job counts to understand demand distribution across different sectors.

---

## 📂 Final Deliverables

- Cleaned dataset stored in the same SQL table (`Uncleaned_DS_jobs`) with additional, well-structured columns.
- SQL script file: `Glassdoor_Data_Cleaning_Project.sql` containing all queries used in the project.

---

## ✅ Why This Project?

Data cleaning is one of the most critical steps in the data analysis pipeline. This project demonstrates the ability to:
- Understand and preprocess real-world job data,
- Apply SQL skills to transform unstructured data,
- Create a structured, analysis-ready dataset that can be used for further analytics, visualization, or modeling.
