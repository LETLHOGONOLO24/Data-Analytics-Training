# Day 6 R exercise
# Task: Evaluate regression model

library(tidyverse)

df <- read.csv('C:/Users/HLOGIZNBUCKS/Downloads/Data-Analytics-Training/Brazilian_E-commerce/olist_order_items_dataset.csv') %>%
  mutate(order_value = price + freight_value)

model <- lm(order_value ~ price + freight_value, data = df)

summary(model)

# Predictions
pred <- predict(model, df)

# RMSE
rmse <- sqrt(mean((df$order_value - pred)^2))
rmse