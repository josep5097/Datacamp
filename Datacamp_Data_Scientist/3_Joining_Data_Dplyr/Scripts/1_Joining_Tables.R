# Libreria ====
library(dplyr)
# Data ====
parts <- readRDS("Data/parts.rds")
part_categories <- readRDS("Data/part_categories.rds")
inventory_parts <- readRDS("Data/inventory_parts.rds")
sets <- readRDS("Data/sets.rds")
inventories <- readRDS("Data/inventories.rds")
colors <- readRDS("Data/colors.rds")

# The inner_join bring tables together!
# Add the correct verb, table, and joining column
parts %>% 
  inner_join(part_categories, 
             by = c("part_cat_id" = "id"))

# Use the suffix argument to replace .x and .y suffixes
# With this option, we include the suffix of categories.
parts %>% 
  inner_join(part_categories, 
             by = c("part_cat_id" = "id"), 
             suffix = c("_part", "_category"))

# Joining with a one-to-many relationship ====
# Combine the parts and inventory_parts tables
parts %>%
  inner_join(inventory_parts, 
             by = "part_num")

# Joining three tables ====
# we can string together multiple joins, by using pipe
sets %>%
  # Add inventories using an inner join 
  inner_join(inventories, by = "set_num") %>%
  # Add inventory_parts using an inner join 
  inner_join(inventory_parts, by = c("id" = "inventory_id"))%>%
  # Adding color table
  inner_join(colors, by = c("color_id" = "id"), suffix=c("_set", "_color"))%>%
  # Count the number of colors and sort
  count(name_color, sort = TRUE)