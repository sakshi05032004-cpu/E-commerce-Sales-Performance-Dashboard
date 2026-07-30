import plotly.express as px

def sales_by_category(df):
    return px.bar(df.groupby("Category",as_index=False)["Sales"].sum(),
                  x="Category",y="Sales")
