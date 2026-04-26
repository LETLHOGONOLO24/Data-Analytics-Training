"""

Exercise_26

Tasks
-Create customer features:
    total spending
    number of orders

-Apply KMeans clustering
-Assign customers to clusters

"""

import pandas as pd
from sklearn.cluster import KMeans

# Lets load the data
orders = pd.read_csv(r"C:\Users\HLOGIZNBUCKS\Downloads\Data-Analytics-Training\Brazilian_E-commerce\olist_orders_dataset.csv")
order_items = pd.read_csv(r"C:\Users\HLOGIZNBUCKS\Downloads\Data-Analytics-Training\Brazilian_E-commerce\olist_order_items_dataset.csv")

# Lets merge the data
df = order_items.merge(orders, on='order_id')
df['order_value'] = df['price'] + df['freight_value']

# Lets create features
customer = df.groupby('customer_id').agg({
    'order_value':'sum',
    'order_id':'nunique'
}).rename(columns={'order_id':'num_orders'})

# Applying KMeans
kmeans = KMeans(n_clusters=3, random_state=42)
customer['cluster'] = kmeans.fit_predict(customer) 
print(customer.groupby('cluster').mean())