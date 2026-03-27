
# Calculate mean, median revenue
# Revenue per category
# Monthly revenue
# Plot revenue trend
  


library(tidyverse)
library(lubridate)


# Lets load the datasets
orders <- read.csv('C:/Users/HLOGIZNBUCKS/Downloads/Data-Analytics-Training/Brazilian_E-commerce/olist_orders_dataset.csv')
order_items <- read.csv('C:/Users/HLOGIZNBUCKS/Downloads/Data-Analytics-Training/Brazilian_E-commerce/olist_order_items_dataset.csv')

# Lets merge order_items with orders
df <- order_items %>%
  left_join(orders, by = "order_id")

# Lets create a revenue column
df <- df %>%
  mutate(order_value = price + freight_value)

# Summary stats
mean(df$order_value, na.rm = TRUE)
median(df$order_value, na.rm = TRUE)

# lets calculate monthly revenue
df <- df %>%
  mutate(month = floor_date(ymd_hms(order_purchase_timestamp), "month"))

monthly <- df %>%
  group_by(month) %>%
  summarise(revenue = sum(order_value))

ggplot(monthly, aes(x = month, y = revenue)) + 
  geom_line()