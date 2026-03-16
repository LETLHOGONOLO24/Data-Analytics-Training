

library(tidyverse)

# 1. Load the datasets

orders <- read_csv('C:/Users/HLOGIZNBUCKS/Downloads/Data/Brazilian_E-commerce/olist_orders_dataset.csv')
items <- read_csv('C:/Users/HLOGIZNBUCKS/Downloads/Data/Brazilian_E-commerce/olist_order_items_dataset.csv')
products <- read_csv('C:/Users/HLOGIZNBUCKS/Downloads/Data/Brazilian_E-commerce/olist_products_dataset.csv')

# 2. Join the datasets
# inner_join automatically finds common column names like 'order_id' and 'product_id'
df_final <- orders %>%
  inner_join(items, by = "order_id") %>%
  inner_join(products, by = "product_id")

# 3. Calculations
# First, create the order_value column
df_final <- df_final %>%
  mutate(order_value = price + freight_value)

# Calculate metrics
total_orders <- n_distinct(df_final$order_id)
avg_order_value <- mean(df_final$order_value, na.rm = TRUE)

# Revenue per category
revenue_per_cat <- df_final %>%
  group_by(product_category_name) %>%
  summarize(total_revenue = sum(order_value, na.rm = TRUE)) %>%
  arrange(desc(total_revenue))

# 4. Create a ggplot bar chart
# We'll take the top 10 categories for clarity
top_10 <- head(revenue_per_cat, 10)

ggplot(top_10, aes(x = reorder(product_category_name, total_revenue), y = total_revenue)) +
  geom_col(fill = "steelblue") +
  coord_flip() + # Makes it easier to read category names
  labs(title = "Top 10 Product Categories by Revenue",
       x = "Category",
       y = "Total Revenue (BRL)") +
  theme_minimal()