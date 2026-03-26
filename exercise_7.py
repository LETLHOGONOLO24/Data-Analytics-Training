import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

orders = pd.read_csv(r"C:\Users\HLOGIZNBUCKS\Downloads\Data-Analytics-Training\Brazilian_E-commerce\olist_orders_dataset.csv")
order_items = pd.read_csv(r"C:\Users\HLOGIZNBUCKS\Downloads\Data-Analytics-Training\Brazilian_E-commerce\olist_order_items_dataset.csv")
products = pd.read_csv(r"C:\Users\HLOGIZNBUCKS\Downloads\Data-Analytics-Training\Brazilian_E-commerce\olist_products_dataset.csv")

# Lets merge data
df = order_items.merge(products, on='product_id', how='left')
df = df.merge(orders, on='order_id', how='left')

# Lets convert Dates
df['order_purchase_timestamp'] = pd.to_datetime(df['order_purchase_timestamp'])
df['order_delivered_customer_date'] = pd.to_datetime(df['order_delivered_customer_date'])

df['order_purchase_timestamp'] = pd.to_datetime(df['order_purchase_timestamp'])
df['order_delivered_customer_date'] = pd.to_datetime(df['order_delivered_customer_date'])

# Feature 1: Delivery time
df['delivery_time'] = (df['order_delivered_customer_date'] - df['order_purchase_timestamp']).dt.days

# Feature 2: Order Month
df['order_month'] = df['order_purchase_timestamp'].dt.to_period('M')

# Feature 3: Day of Week
df['order_day'] = df['order_purchase_timestamp'].dt.day_name()

# Feature 4: Hour
df['order_hour'] = df['order_purchase_timestamp'].dt.hour

# Late Delivery Flag
df['is_late'] = np.where(df['delivery_time'] > 7, 1, 0)

# Analysis: Average Delivery Time
avg_delivery = df['delivery_time'].mean()
print(avg_delivery)

# Analysis: % Late Deliveries
late_percentage = df['is_late'].mean() * 100
print(late_percentage)

# Analysis: Delivery Time by Category
delivery_by_category = df.groupby('product_category_name')['delivery_time'].mean().sort_values(ascending=False)
print(delivery_by_category)

# Lets visualize
plt.figure()
df['delivery_time'].hist(bins=30)
plt.title("Delivery Time Distribution")
plt.xlabel("Days")
plt.ylabel("Frequency")
plt.show()

late_by_category = df.groupby('product_category_name')['is_late'].sum().sort_values(ascending=False).head(10)

plt.figure()
late_by_category.plot(kind='bar')
plt.title("Late Deliveries by Category")
plt.xticks(rotation=45)
plt.show()