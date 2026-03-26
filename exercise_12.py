"""

Exercise_12 - GROUPBY + ADVANCED ANALYSIS

-Compute revenue per customer
-Find top 10 customers

-Calculate monthly revenue
-Compute cumulative revenue
-Visualize revenue trend


"""

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

orders = pd.read_csv(r"C:\Users\HLOGIZNBUCKS\Downloads\Data-Analytics-Training\Brazilian_E-commerce\olist_orders_dataset.csv")
order_items = pd.read_csv(r"C:\Users\HLOGIZNBUCKS\Downloads\Data-Analytics-Training\Brazilian_E-commerce\olist_order_items_dataset.csv")

# Lets merge the data
df = order_items.merge(orders, on='order_id')

# Lets create revenue/order_value column
df['order_value'] = df['price'] + df['freight_value']

# Revenue per customer
customer_revenue = df.groupby('customer_id')['order_value'].sum()
print(customer_revenue)

# Top 10 customers
top10 = customer_revenue.sort_values(ascending=False).head(10)
print(top10)

# Monthly revenue
df['order_purchased_timestamp'] = pd.to_datetime(df['order_purchase_timestamp'])
df['month'] = df['order_purchased_timestamp'].dt.to_period('M')

monthly_revenue = df.groupby('month')['order_value'].sum()

# Cumulative revenue
cumulative_revenue = monthly_revenue.cumsum()

# Lets plot
plt.figure()
monthly_revenue.plot(label='Monthly Revenue')
cumulative_revenue.plot(label='Cumulative Revenue')
plt.legend()
plt.title("Revenue Trend")
plt.show()