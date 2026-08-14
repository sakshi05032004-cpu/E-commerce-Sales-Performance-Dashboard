Data Cleaning & Preprocessing

import pandas as pd
import numpy as np
import os

1. FILE PATHS

INPUT_FILE = "../data/ecommerce_sales.xlsx"
OUTPUT_FILE = "../data/ecommerce_sales_cleaned.csv"


2. LOAD DATA

print("Loading dataset...")

df = pd.read_excel(INPUT_FILE)

print("\nDataset loaded successfully!")
print("Rows:", df.shape[0])
print("Columns:", df.shape[1])



3. DISPLAY BASIC INFORMATION

print("\nDATASET INFO ")

print("\nColumn Names:")
print(df.columns.tolist())

print("\nFirst 5 Rows:")
print(df.head())

print("\nDataset Shape:")
print(df.shape)

print("\nData Types:")
print(df.dtypes)


4. CLEAN COLUMN NAMES


Remove leading/trailing spaces

df.columns = df.columns.str.strip()

Remove BOM character if present

df.columns = df.columns.str.replace("\ufeff", "", regex=False)

Replace spaces with underscores

df.columns = df.columns.str.replace(" ", "_")

print("\nCleaned Column Names:")
print(df.columns.tolist())



6. CHECK DUPLICATE RECORDS


duplicates = df.duplicated().sum()

print("Duplicate rows:", duplicates)

if duplicates > 0:
df.drop_duplicates(inplace=True)
print("Duplicate rows removed.")
else:
print("No duplicate rows found.")



7. CHECK MISSING VALUES



print("\n========== MISSING VALUES ==========")

missing_values = df.isnull().sum()

print(missing_values[missing_values > 0])



8. HANDLE MISSING VALUES



Numeric columns

numeric_columns = df.select_dtypes(
include=["int64", "float64"]
).columns

for col in numeric_columns:
if df[col].isnull().sum() > 0:
df[col] = df[col].fillna(df[col].median())

Categorical columns

categorical_columns = df.select_dtypes(
include=["object"]
).columns

for col in categorical_columns:
if df[col].isnull().sum() > 0:
df[col] = df[col].fillna("Unknown")

print("Missing values handled.")



9. CONVERT DATE COLUMNS



date_columns = [
"Order_Date",
"Ship_Date"
]

for col in date_columns:
if col in df.columns:
df[col] = pd.to_datetime(
df[col],
errors="coerce"
)

print("\nDate columns converted successfully.")

============================================================

10. CHECK INVALID DATES

============================================================

for col in date_columns:

if col in df.columns:

    invalid_dates = df[col].isnull().sum()

    print(
        f"Invalid dates in {col}:",
        invalid_dates
    )

============================================================

11. CLEAN TEXT COLUMNS

============================================================

text_columns = [
"Ship_Mode",
"Customer_ID",
"Customer_Name",
"Segment",
"Country",
"City",
"State",
"Region",
"Product_ID",
"Category",
"Sub-Category",
"Product_Name"
]

for col in text_columns:

if col in df.columns:

    df[col] = (
        df[col]
        .astype(str)
        .str.strip()
    )

print("\nText columns cleaned.")

============================================================

12. CONVERT NUMERIC COLUMNS

============================================================

numeric_columns = [
"Sales",
"Quantity",
"Discount",
"Profit",
"Postal_Code"
]

for col in numeric_columns:

if col in df.columns:

    df[col] = pd.to_numeric(
        df[col],
        errors="coerce"
    )

============================================================

13. HANDLE INVALID NUMERIC VALUES

============================================================

for col in [
"Sales",
"Quantity",
"Discount",
"Profit"
]:

if col in df.columns:

    df[col] = df[col].fillna(0)

============================================================

14. REMOVE INVALID SALES RECORDS

============================================================

if "Sales" in df.columns:

invalid_sales = df[df["Sales"] < 0]

print(
    "\nNegative sales records:",
    len(invalid_sales)
)

# Remove negative sales values
df = df[df["Sales"] >= 0]

============================================================

15. VALIDATE QUANTITY

============================================================

if "Quantity" in df.columns:

invalid_quantity = df[
    df["Quantity"] <= 0
]

print(
    "Invalid quantity records:",
    len(invalid_quantity)
)

df = df[df["Quantity"] > 0]

============================================================

16. VALIDATE DISCOUNT

============================================================

if "Discount" in df.columns:

print(
    "Discount range:",
    df["Discount"].min(),
    "to",
    df["Discount"].max()
)

# Keep discount between 0 and 1
df["Discount"] = df["Discount"].clip(
    lower=0,
    upper=1
)

============================================================

17. CREATE YEAR COLUMN

============================================================

if "Order_Date" in df.columns:

df["Year"] = df["Order_Date"].dt.year

============================================================

18. CREATE MONTH COLUMN

============================================================

if "Order_Date" in df.columns:

df["Month"] = df["Order_Date"].dt.month

============================================================

19. CREATE MONTH NAME COLUMN

============================================================

if "Order_Date" in df.columns:

df["Month_Name"] = (
    df["Order_Date"]
    .dt.month_name()
)

============================================================

20. CREATE QUARTER COLUMN

============================================================

if "Order_Date" in df.columns:

df["Quarter"] = (
    "Q"
    + df["Order_Date"]
    .dt.quarter
    .astype(str)
)

============================================================

21. CREATE YEAR-MONTH COLUMN

============================================================

if "Order_Date" in df.columns:

df["Year_Month"] = (
    df["Order_Date"]
    .dt.to_period("M")
    .astype(str)
)

============================================================

22. CREATE REVENUE COLUMN

============================================================

In this dataset Sales represents revenue.

Therefore Revenue is based on Sales.

if "Sales" in df.columns:

df["Revenue"] = df["Sales"]

============================================================

23. CREATE PROFIT MARGIN

============================================================

if "Revenue" in df.columns and "Profit" in df.columns:

df["Profit_Margin"] = np.where(
    df["Revenue"] != 0,
    (df["Profit"] / df["Revenue"]) * 100,
    0
)

============================================================

24. CREATE AVERAGE ORDER VALUE

============================================================

Calculate order-level revenue first.

if "Order_ID" in df.columns:

order_revenue = (
    df.groupby("Order_ID")["Revenue"]
    .transform("sum")
)

df["Order_Value"] = order_revenue

============================================================

25. CREATE CUSTOMER ORDER COUNT

============================================================

if "Customer_ID" in df.columns:

customer_orders = (
    df.groupby("Customer_ID")["Order_ID"]
    .transform("nunique")
)

df["Customer_Order_Count"] = customer_orders

============================================================

26. CREATE CUSTOMER TYPE

============================================================

if "Customer_Order_Count" in df.columns:

df["Customer_Type"] = np.where(
    df["Customer_Order_Count"] > 1,
    "Returning Customer",
    "New Customer"
)

============================================================

27. CREATE PRODUCT REVENUE

============================================================

if "Product_ID" in df.columns:

product_revenue = (
    df.groupby("Product_ID")["Revenue"]
    .transform("sum")
)

df["Product_Total_Revenue"] = product_revenue

============================================================

28. CREATE PROFIT CATEGORY

============================================================

if "Profit" in df.columns:

df["Profit_Status"] = np.where(
    df["Profit"] > 0,
    "Profitable",
    np.where(
        df["Profit"] < 0,
        "Loss",
        "Break-even"
    )
)

============================================================

29. CREATE SALES PERFORMANCE CATEGORY

============================================================

if "Revenue" in df.columns:

revenue_median = df["Revenue"].median()

df["Sales_Performance"] = np.where(
    df["Revenue"] >= revenue_median,
    "High Sales",
    "Low Sales"
)

============================================================

30. SORT DATA

============================================================

if "Order_Date" in df.columns:

df = df.sort_values(
    by="Order_Date"
)

============================================================

31. RESET INDEX

============================================================

df.reset_index(
drop=True,
inplace=True
)

============================================================

32. ROUND DECIMAL VALUES

============================================================

decimal_columns = [
"Sales",
"Revenue",
"Profit",
"Discount",
"Profit_Margin",
"Order_Value"
]

for col in decimal_columns:

if col in df.columns:

    df[col] = df[col].round(2)

============================================================

33. FINAL DATA QUALITY CHECK

============================================================

print("\n========== FINAL DATA QUALITY CHECK ==========")

print("\nFinal Shape:")
print(df.shape)

print("\nRemaining Missing Values:")

missing = df.isnull().sum()

print(
missing[missing > 0]
)

print("\nDuplicate Rows:")
print(df.duplicated().sum())

print("\nData Types:")
print(df.dtypes)

============================================================

34. KPI SUMMARY

============================================================

print("\n========== KPI SUMMARY ==========")

if "Revenue" in df.columns:

print(
    "Total Revenue:",
    round(df["Revenue"].sum(), 2)
)

if "Profit" in df.columns:

print(
    "Total Profit:",
    round(df["Profit"].sum(), 2)
)

if "Quantity" in df.columns:

print(
    "Total Quantity Sold:",
    df["Quantity"].sum()
)

if "Order_ID" in df.columns:

print(
    "Total Orders:",
    df["Order_ID"].nunique()
)

if "Customer_ID" in df.columns:

print(
    "Total Customers:",
    df["Customer_ID"].nunique()
)

if "Revenue" in df.columns and "Order_ID" in df.columns:

total_revenue = df["Revenue"].sum()
total_orders = df["Order_ID"].nunique()

aov = (
    total_revenue / total_orders
    if total_orders != 0
    else 0
)

print(
    "Average Order Value:",
    round(aov, 2)
)

============================================================

35. SAVE CLEANED DATA

============================================================

output_directory = os.path.dirname(
OUTPUT_FILE
)

if output_directory:
os.makedirs(
output_directory,
exist_ok=True
)

df.to_csv(
OUTPUT_FILE,
index=False
)

print("\n==========================================")
print("DATA CLEANING COMPLETED SUCCESSFULLY")
print("==========================================")

print(
"\nCleaned dataset saved to:",
OUTPUT_FILE
)

print(
"\nFinal dataset shape:",
df.shape
)
