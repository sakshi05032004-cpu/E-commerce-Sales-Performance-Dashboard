import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
df = pd.read_csv("/Users/visheshpatel/Downloads/Walmart_Sales.csv")
df.head()

df.tail()

df.info()

df.describe()

df.shape

df.columns
df.isnull().sum()
df.dropna(inplace=True)
df.drop_duplicates(inplace=True)
df["Order Date"] = pd.to_datetime(df["Order Date"])
df["Revenue"] = df["Quantity"] * df["Unit Price"]
df["Profit Margin"] = (df["Profit"]/df["Revenue"])*100
df["Month"] = df["Order Date"].dt.month_name()
df["Year"] = df["Order Date"].dt.year
df["Quarter"] = df["Order Date"].dt.quarter
total_revenue = df["Revenue"].sum()

total_profit = df["Profit"].sum()

total_orders = df["Order ID"].nunique()

total_customers = df["Customer ID"].nunique()

average_order_value = total_revenue / total_orders
df.groupby("Category")["Revenue"].sum()
df.groupby("Region")["Revenue"].sum()
df.groupby("Product Name")["Revenue"].sum().sort_values(ascending=False).head(10)
df.groupby("Customer Name")["Revenue"].sum().sort_values(ascending=False).head(10)
df.groupby("Month")["Revenue"].sum()
df.to_csv("cleaned_sales.csv",index=False)
