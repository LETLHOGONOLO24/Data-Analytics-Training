library(tidyverse)
library(lubridate)


# Lets load the datasets
orders <- read.csv('C:/Users/HLOGIZNBUCKS/Downloads/Data-Analytics-Training/Brazilian_E-commerce/olist_orders_dataset.csv')
order_items <- read.csv('C:/Users/HLOGIZNBUCKS/Downloads/Data-Analytics-Training/Brazilian_E-commerce/olist_order_items_dataset.csv')
products <- read.csv('C:/Users/HLOGIZNBUCKS/Downloads/Data-Analytics-Training/Brazilian_E-commerce/olist_products_dataset.csv')

# Lets join data
df <- order_items %>%
  left_join(products, by = "product_id") %>%
  left_join(orders, by = "order_id")

# Lets convert dates
df$order_purchase_timestamp <- ymd_hms(df$order_purchase_timestamp)
df$order_delivered_customer_date <- ymd_hms(df$order_delivered_customer_date)

# Feature Engineering
df <- df %>%
  mutate(
    delivery_time = as.numeric(difftime(order_delivered_customer_date, order_purchase_timestamp, units = "days")),
    is_late = ifelse(delivery_time > 7, 1, 0)
  )

# Avg Delivery Time
mean(df$delivery_time, na.rm = TRUE)

# Late Deliveries per Category
df %>%
  group_by(product_category_name) %>%
  summarise(late_count = sum(is_late, na.rm = TRUE))

# Lets visualize
ggplot(df, aes(x = product_category_name, y = delivery_time)) +
  geom_boxplot() +
  coord_flip()

df %>%
  group_by(product_category_name) %>%
  summarise(late = sum(is_late)) %>%
  top_n(10, late) %>%
  ggplot(aes(x = reorder(product_category_name, late), y = late)) +
  geom_bar(stat = "identity") +
  coord_flip()
