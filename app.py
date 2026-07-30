import streamlit as st
import pandas as pd
from src.data_loader import load_data
from src.analytics import total_sales

st.set_page_config(page_title="Sales Dashboard", layout="wide")
st.title("📊 E-Commerce Sales Dashboard")

try:
    df = load_data("data/ecommerce_sales.csv")
    st.metric("Total Sales", f"{total_sales(df):,.2f}")
    st.dataframe(df.head())
except Exception:
    st.info("Add ecommerce_sales.csv inside the data folder.")
