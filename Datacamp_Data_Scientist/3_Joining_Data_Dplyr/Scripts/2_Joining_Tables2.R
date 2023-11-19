# Left joining two sets by part and color ====
library(dplyr)
library(tidyr) # help to create tidy data
library(tidyverse) # in tidyverse is incluiding tidyr
library(forcats)
library(ggplot2)

# Data ====
parts <- readRDS("Data/parts.rds")
part_categories <- readRDS("Data/part_categories.rds")
inventory_parts <- readRDS("Data/inventory_parts.rds")
sets <- readRDS("Data/sets.rds")
inventories <- readRDS("Data/inventories.rds")
colors <- readRDS("Data/colors.rds")


# Manipulation ====
inventory_parts_joined <- sets %>%
  inner_join(inventories, 
             by = "set_num") %>%
  inner_join(inventory_parts, 
             by = c("id" = "inventory_id")) %>%
  inner_join(colors, 
             by = c("color_id" = "id"), 
             suffix=c("_set", 
                      "_color")) %>%
  select(c("set_num", 
           "part_num", 
           "color_id", 
           "quantity")) %>% 
  arrange(desc(quantity))

## Millennium falcom ====
millennium_falcon <- inventory_parts_joined %>%
  filter(set_num == "7965-1")
## Star Destroyer ====
star_destroyer <- inventory_parts_joined %>%
  filter(set_num == "75190-1")

# Combine the star_destroyer and millennium_falcon tables
# Combining on millenium falcom dataset
C1 <- millennium_falcon %>% 
  left_join(star_destroyer, 
            by = c("part_num",
                   "color_id"),
            suffix = c("_falcon", 
                       "_star_destroyer"))
# We can determine the freq that a specific piece appears.

# Left joining 2 sets by color ====
# Aggregate Millennium Falcon for the total quantity in each part
millennium_falcon_colors <- millennium_falcon %>%
  group_by(color_id) %>%
  summarize(total_quantity = sum(quantity))

# Aggregate Star Destroyer for the total quantity in each part
star_destroyer_colors <- star_destroyer %>%
  group_by(color_id) %>%
  summarize(total_quantity = sum(quantity))

# Left join the Millennium Falcon colors to the Star Destroyer colors
millennium_falcon_colors %>%
  left_join(star_destroyer_colors, 
            by = "color_id", 
            suffix= c("_falcon", 
                      "_star_destroyer"))

# Finding an observation that doesn’t have a match ====
## Assumption> All sets would have at least a version

# Inventories version 1
inventory_version_1 <- inventories %>%
  filter(version == 1)

# Join versions to sets
sets %>%
  left_join(inventory_version_1, 
            by = "set_num") %>%
  # Filter for where version is na
  filter(is.na(version))
# There are cases where does not have an original version.

# The right-join verb ====
parts %>%
  # Count the part_cat_id
  count(part_cat_id) %>%
  # Right join part_categories
  right_join(part_categories, by = c("part_cat_id" = "id"))%>%
  # Filter for NA
  filter(is.na(n))
# We could find an instance where a parte category is in one table 
# but missing from the other one.


# Replacing NA values ====
# To cleaning up the table.
parts %>%
  count(part_cat_id) %>%
  right_join(part_categories, by = c("part_cat_id" = "id")) %>%
  # Use replace_na to replace missing values in the n column
  replace_na(list(n = 0))

# Joining tables to themselves ====
# Joining themes to their children 
themes <- readRDS("Data/themes.rds")
themes
# Technic is the principal, ids 2,3 4 and 5 are their children.
# But 5 is the new parent.

themes %>% 
  # Inner join the themes table
  inner_join(themes, by = c("id" = "parent_id"), 
             suffix = c("_parent", "_child")) %>% 
  # Filter for the "Harry Potter" parent name 
  filter(name_parent == "Harry Potter")
# Harry Potter parent theme has a few children.

## Joining thems to their grandchildren
# Inner join themes to a filtered version of itself to stablish connection
# Join themes to itself again to find the grandchild relationships
themes %>% 
  inner_join(themes, by = c("id" = "parent_id"), 
             suffix = c("_parent", "_child")) %>%
  inner_join(themes, by = c("id_child" = "parent_id"),
             suffix = c("_parent", "_grandchild"))

## Determine which theme does not have children
themes %>% 
  # Left join the themes table to its own children
  left_join(themes, by = c("id" = "parent_id"), suffix = c("_parent", "_child")) %>%
  # Filter for themes that have no child themes
  filter(is.na(name_child))
# There are 586 themes in total.

# The full_join verb ====
# Differences between Batman and Star Wars
inventory_parts_joined <- inventories %>%
  inner_join(inventory_parts, 
             by = c("id" = "inventory_id")) %>%
  arrange(desc(quantity)) %>%
  select(-id, -version)

# Start with inventory_parts_joined table
inventory_sets_themes <- inventory_parts_joined %>%
  # Combine with the sets table 
  inner_join(sets, 
             by = "set_num") %>%
  # Combine with the themes table
  inner_join(themes, 
             by = c("theme_id" = "id"), 
             suffix = c("_set", "_theme"))

# Obtaining the information of batman
batman <- inventory_sets_themes %>%
  filter(name_theme == "Batman")

# Obtaining the information of Star Wars
star_wars <- inventory_sets_themes %>%
  filter(name_theme == "Star Wars")

## Manipulating both ====
# Count the part number and color id, weight by quantity
batman_parts <- batman %>%
  count(part_num, color_id, wt = quantity)

star_wars_parts<- star_wars %>%
  count(part_num, color_id, wt = quantity)

parts_joined <- batman_parts %>%
  # Combine the star_wars_parts table 
  full_join(star_wars_parts, 
            by = c("part_num", "color_id"), 
            suffix = c("_batman", "_star_wars")) %>%
  # Replace NAs with 0s in the n_batman and n_star_wars columns 
  replace_na(list(n_batman = 0,
                  n_star_wars = 0))

# Comparing Batman and Star Wars LEGO parts
parts_joined %>%
  # Sort the number of star wars pieces in descending order 
  arrange(desc(n_star_wars)) %>%
  # Join the colors table to the parts_joined table
  inner_join(colors, by = c("color_id" = "id")) %>%
  # Join the parts table to the previous join 
  inner_join(parts, by = "part_num", suffix = c("_color", "_part"))

# The semi- and anti-join verbs ====
batmobile <- inventory_parts_joined %>%
  filter(set_num == "7784-1") %>%
  select(-set_num)

batwing <- inventory_parts_joined %>%
  filter(set_num == "70916-1") %>%
  select(-set_num)

# Filter the batwing set for parts that are also in the batmobile set
batwing %>%
  semi_join(batmobile, by = c("part_num"))
# Filter the batwing set for parts that aren't in the batmobile set
batwing %>%
  anti_join(batmobile, by = c("part_num"))
# There are 126 parts in both sets, and 183 parts that are in the 
# batwing set that are not in the batmobile set.

## What colors are included in at least one set? ====
# Use inventory_parts to find colors included in at least one set
colors %>%
  semi_join(inventory_parts, 
            by = c("id" = "color_id")) 
# There are 179 colors in the colors table and 134 colors that are
# included in at least one set.

## Which set is missing version 1? ====
# Use filter() to extract version 1 
version_1_inventories <- inventories %>%
  filter(version == 1)

# Use anti_join() to find which set is missing a version 1
sets %>%
  anti_join(version_1_inventories, by = "set_num")

# Visualizing set differences
inventory_parts_themes <- inventories %>%
  inner_join(inventory_parts, by = c("id" = "inventory_id")) %>%
  arrange(desc(quantity)) %>%
  select(-id, -version) %>%
  inner_join(sets, by = "set_num") %>%
  inner_join(themes, by = c("theme_id" = "id"), suffix = c("_set", "_theme"))
inventory_parts_themes

batman_colors <- inventory_parts_themes %>%
  # Filter the inventory_parts_themes table for the Batman theme
  filter(name_theme == "Batman") %>%
  group_by(color_id) %>%
  summarize(total = sum(quantity)) %>%
  # Add a percent column of the total divided by the sum of the total 
  mutate(fraction = total / sum(total))

batman_colors

# Filter and aggregate the Star Wars set data; add a percent column
star_wars_colors <- inventory_parts_themes %>%
  filter(name_theme == "Star Wars") %>%
  group_by(color_id) %>%
  summarize(total = sum(quantity)) %>%
  mutate(fraction = total / sum(total))

star_wars_colors

## Combining sets ====
colors_joined <- batman_colors %>%
  # Join the Batman and Star Wars colors
  full_join(star_wars_colors, by = "color_id", suffix = c("_batman", "_star_wars")) %>%
  # Replace NAs in the total_batman and total_star_wars columns
  replace_na(list(total_batman = 0, total_star_wars = 0)) %>%
  inner_join(colors, by = c("color_id" = "id"))%>%
  # Create the difference and total columns
  mutate(difference = fraction_batman - fraction_star_wars,
         total = total_batman + total_star_wars) %>%
  # Filter for totals greater than 200
  filter(total >= 200)%>%
  mutate(name = fct_reorder(name, difference))%>%
  drop_na()
colors_joined

# Create a bar plot using colors_joined and the name and difference columns
color_palette <- setNames(colors_joined$rgb, colors_joined$name)

ggplot(colors_joined, aes(name, difference, fill = name)) +
  geom_col() +
  coord_flip() +
  scale_fill_manual(values = color_palette, guide = FALSE) +
  labs(y = "Difference: Batman - Star Wars")
