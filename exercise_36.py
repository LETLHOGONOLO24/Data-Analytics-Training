"""

Exercise_36

-Create customer features:
    total spending
    number of orders

-Sacale features using StandardScaler
-Compare before vs after scaling

"""

import pandas as pd
from sklearn.preprocessing import StandardScaler

# Lets load the data
orders = pd.read_csv(r"C:\Users\HLOGIZNBUCKS\Downloads\Data-Analytics-Training\Brazilian_E-commerce\olist_orders_dataset.csv")
order_items = pd.read_csv(r"C:\Users\HLOGIZNBUCKS\Downloads\Data-Analytics-Training\Brazilian_E-commerce\olist_order_items_dataset.csv")

df = order_items.merge(orders, on='order_id')
df['order_value'] = df['price'] + df['freight_value']

# Lets create features
customer = df.groupby('customer_id').agg({
    'order_value':'sum',
    'order_id':'nunique'
}).rename(columns={'order_id':'num_orders'})

# Scaling
scaler = StandardScaler()
scaled = scaler.fit_transform(customer)

scaled_df = pd.DataFrame(scaled, columns=customer.columns)
print(scaled_df.head())