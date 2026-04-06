"""

LETS FILER DATA

"""

import pandas as pd

# Load two main CSV files
orders = pd.read_csv(r"C:\Users\HLOGIZNBUCKS\Downloads\Data-Analytics-Training\Brazilian_E-commerce\olist_orders_dataset.csv")
order_items = pd.read_csv(r"C:\Users\HLOGIZNBUCKS\Downloads\Data-Analytics-Training\Brazilian_E-commerce\olist_order_items_dataset.csv")

# 1. Filter orders by status (e.g., delivered orders only)
delivered_orders = orders[orders['order_status'] == 'delivered']
print(f"\nDelivered orders: {len(delivered_orders)}")

# 2. Filter expensive items (price > 200)
expensive_items = order_items[order_items['price'] > 200]
print(f"Expensive items: {len(expensive_items)}\n")

# 3. Filter by multiple conditions (price > 200 AND freight < 30)
high_value_items = order_items[(order_items['price'] > 200) & (order_items['freight_value'] < 30)]
print(f"High value items with cheap shipping: {len(high_value_items)}")

# 4. Filter by string matching (orders from São Paulo - requires merging)
# First merge orders with customers
customers = pd.read_csv(r'C:\Users\HLOGIZNBUCKS\Downloads\Data-Analytics-Training\Brazilian_E-commerce\olist_customers_dataset.csv')
orders_with_customers = orders.merge(customers, on='customer_id')
sp_orders = orders_with_customers[orders_with_customers['customer_state'] == 'SP']
print(f"Orders from São Paulo: {len(sp_orders)}\n")

# 5. Filter by date range
orders['order_purchase_date'] = pd.to_datetime(orders['order_purchase_timestamp'])
jan_2018_orders = orders[(orders['order_purchase_date'] >= '2018-01-01') & 
                          (orders['order_purchase_date'] <= '2018-01-31')]
print(f"Orders in January 2018: {len(jan_2018_orders)}")

# 6. Filter based on another dataframe (orders that have expensive items)
expensive_order_ids = expensive_items['order_id'].unique()
orders_with_expensive_items = orders[orders['order_id'].isin(expensive_order_ids)]
print(f"Orders containing expensive items: {len(orders_with_expensive_items)}")


"""
# Save any filtered result to a new CSV
expensive_items.to_csv('expensive_items.csv', index=False)
sp_orders.to_csv('sp_orders.csv', index=False)

print("\nFiltering complete! Check the new CSV files.")

"""