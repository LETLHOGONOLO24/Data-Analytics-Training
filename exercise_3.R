library(tidyverse)

# Load the datasets
orders <- read.csv('C:/Users/HLOGIZNBUCKS/Downloads/Data-Analytics-Training/Brazilian_E-commerce/olist_orders_dataset.csv')
order_items <- read.csv('C:/Users/HLOGIZNBUCKS/Downloads/Data-Analytics-Training/Brazilian_E-commerce/olist_order_items_dataset.csv')
products <- read.csv('C:/Users/HLOGIZNBUCKS/Downloads/Data-Analytics-Training/Brazilian_E-commerce/olist_products_dataset.csv')

# Join the datasets
df <- order_items %>%
  left_join(products, by = "product_id") %>%
  left_join(orders, by = "order_id")

# The code above says df is you taking order_items and then left joining products and orders

# Lets calculate revenue
df <- df %>%
  mutate(order_value = price + freight_value)

# Lets calculate revenue per category
revenue_category <- df %>%
  group_by(product_category_name) %>%
  summarise(total_revenue = sum(order_value)) %>%
  arrange(desc(total_revenue))

# Lets arrange order value
avg_order <- df %>%
  group_by(order_id) %>%
  summarise(order_total = sum(order_value)) %>%
  summarise(avg_order_value = mean(order_total))

# Create a ggplot bar chart
revenue_category %>%
  top_n(10, total_revenue) %>%
  ggplot(aes(x = reorder(product_category_name, total_revenue), y = total_revenue)) +
  geom_bar(stat = "identity") +
  coord_flip() +
  ggtitle("Top Categories by Revenue")