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
orders = pd.read_csv(r'C:\Users\HLOGIZNBUCKS\Downloads\Data\Brazilian_E-commerce\olist_orders_dataset.csv')
items = pd.read_csv(r'C:\Users\HLOGIZNBUCKS\Downloads\Data\Brazilian_E-commerce\olist_order_items_dataset.csv')
products = pd.read_csv(r'C:\Users\HLOGIZNBUCKS\Downloads\Data\Brazilian_E-commerce\olist_products_dataset.csv')

# Lets merge them
df = pd.merge(orders, items, on='order_id')
df = pd.merge(df, products, on='product_id')

# Create a new column
df['order_value'] = df['price'] + df['freight_value']

# Lets calculate total revenue
revenue = df['order_value'].sum()

# Lets calculate average order value
order_value = df['order_value'].mean()

# Lets calculate revenue per category
revenue_category = df.groupby('product_category_name')['order_value'].sum()

# Get top 10 categories
top_10_revenue = df.groupby('product_category_name')['order_value'].sum().sort_values(ascending=False).head(10)

plt.figure(figsize=(10, 6))
top_10_revenue.plot(kind='bar', color='skyblue')
plt.title('Top 10 Product Categories by Revenue')
plt.xlabel('Category')
plt.ylabel('Total Revenue (BRL)')
plt.xticks(rotation=45)
plt.show()