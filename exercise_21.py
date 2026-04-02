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

orders = pd.read_csv("orders.csv")
order_items = pd.read_csv("order_items.csv")

df = order_items.merge(orders, on='order_id')
df['order_value'] = df['price'] + df['freight_value']

customer = df.groupby('customer_id').agg({
    'order_value':'sum',
    'order_id':'nunique'
}).rename(columns={'order_id':'num_orders'})

customer['segment'] = pd.qcut(customer['order_value'], 3, labels=['Low','Medium','High'])
print(customer.head())