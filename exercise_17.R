# EXERCISE
# Distribution of order values
# Log transformation
# Revenue by category
# Density plot

library(tidyverse)

df <- read.csv('C:/Users/HLOGIZNBUCKS/Downloads/Data-Analytics-Training/Brazilian_E-commerce/olist_order_items_dataset.csv') %>%
  mutate(order_value = price + freight_value)

# Distribution
ggplot(df, aes(x = order_value)) +
  geom_histogram(bins = 30)

# Log transform
df <- df %>%
  mutate(log_value = log(order_value + 1))

# Density
ggplot(df, aes(x = log_value)) +
  geom_density()
