"""

Tasks

-Calculate total spending per customer
-Calculate number of orders per customer
-Create simple segments:
    High spenders
    Medium
    Low

"""

import pandas as pd

orders = pd.read_csv(r"C:\Users\HLOGIZNBUCKS\Downloads\Data-Analytics-Training\Brazilian_E-commerce\olist_orders_dataset.csv")
order_items = pd.read_csv(r"C:\Users\HLOGIZNBUCKS\Downloads\Data-Analytics-Training\Brazilian_E-commerce\olist_order_items_dataset.csv")

df = order_items.merge(orders, on='order_id')
df['order_value'] = df['price'] + df['freight_value']

customer = df.groupby('customer_id').agg({
    'order_value':'sum',
    'order_id':'nunique'
}).rename(columns={'order_id':'num_orders'})

customer['segment'] = pd.qcut(customer['order_value'], 3, labels=['Low','Medium','High'])
print(customer.head())