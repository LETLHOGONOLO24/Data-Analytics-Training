"""

Tasks:

Load datasets into Pandas.
Merge orders + order_items + products.

Create a new column:
order_value = price + freight_value

Calculate:
    total revenue
    average order value
    revenue per category

Create a bar chart of top 10 product categories by revenue.

"""

import pandas as pd
import matplotlib.pyplot as plt

# Lets load the specific files need
orders = pd.read_csv('olist_orders_dataset.csv')
items = pd.read_csv('olist_order_items_dataset.csv')
products = pd.read_csv(r'C:\Users\HLOGIZNBUCKS\Downloads\Data-Analytics-Training\Brazilian_E-commerce\olist_products_dataset.csv')

# Lets merge them
df = pd.merge(orders, items, on='order_id', how='left')
df = pd.merge(df, products, on='product_id', how='left')

# Create a new column
df['order_value'] = df['price'] + df['freight_value']

# Lets calculate total revenue
total_revenue = df['order_value'].sum()
print(total_revenue)

# Lets calculate average order value
order_totals = df.groupby('order_id')['order_value'].sum()
avg_order_value = order_totals.mean()
print(avg_order_value)

# Lets calculate revenue per category
revenue_per_category = df.groupby('product_category_name')['order_value'].sum().sort_values(ascending=False)
print(revenue_per_category)

# Get top 10 categories
top_10 = revenue_per_category.head(10)

plt.figure(figsize=(10, 6))
top_10.plot(kind='bar', color='skyblue')
plt.title('Top 10 Product Categories by Revenue')
plt.xlabel('Category')
plt.ylabel('Total Revenue (BRL)')
plt.xticks(rotation=45)
plt.show()