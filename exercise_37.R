# Day 7 R exercise
# Task: Predict whether an order is delivered or not

library(tidyverse)

df <- read.csv('C:/Users/HLOGIZNBUCKS/Downloads/Data-Analytics-Training/Brazilian_E-commerce/olist_orders_dataset.csv')

# Create binary variable
orders <- orders %>%
  mutate(delivered = ifelse(order_status == "delivered", 1, 0))

model <- glm(delivered ~ order_purchase_timestamp, data = orders, family = "binomial")

summary(model)