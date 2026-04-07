# Load packages
library(tidyverse)

# Load data
orders <- read_csv("C:/Users/HLOGIZNBUCKS/Downloads/Data-Analytics-Training/Brazilian_E-commerce/olist_orders_dataset.csv")
customers <- read_csv("C:/Users/HLOGIZNBUCKS/Downloads/Data-Analytics-Training/Brazilian_E-commerce/olist_customers_dataset.csv")

# Check missing values
colSums(is.na(orders))

# Clean orders: replace missing delivery dates with estimated dates
orders_clean <- orders %>%
  mutate(
    order_delivered_customer_date = coalesce(
      order_delivered_customer_date, 
      order_estimated_delivery_date
    )
  )

# Filter: keep only delivered orders
orders_delivered <- orders_clean %>%
  filter(order_status == "delivered")

# Join with customers
final_data <- orders_delivered %>%
  left_join(customers, by = "customer_id")

# See result
glimpse(final_data)