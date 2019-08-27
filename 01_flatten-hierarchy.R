# Flatten hierarchy data
# Matt Dray
# August 2019


# Load packages -----------------------------------------------------------


library(readr)
library(tidyxl)
library(unpivotr)
library(tidyr)
library(dplyr)
library(purrr)
library(collapsibleTree) # https://adeelk93.github.io/collapsibleTree/


# Read data ---------------------------------------------------------------


hierarchy <- read_csv(
  "data/20190711_hierarchy.csv",
  col_names = paste0("level", 0:5)
)


# Prepare data for viz ----------------------------------------------------


# Function to 'flatten' hierarchy data
enhierarch <- function(data, first_level, second_level){
  
  flat <- data %>% 
    select(!! first_level, !! second_level) %>% 
    as_cells(col_names = TRUE) %>% 
    filter(!is.na(chr)) %>%
    behead("WNW", chr0) %>% 
    slice(-1) %>% 
    select(chr0, chr)
  
  return(flat)
  
}

# Create vectors that will provide pairs of columns to our function
first_level_vec <- c("level0", "level1", "level2", "level3", "level4") 
second_level_vec <-c("level1", "level2", "level3", "level4", "level5") 

# Use the function over the vector pairs
hier_list <- map2(
  .x = first_level_vec,
  .y = second_level_vec,
  ~enhierarch(hierarchy, .x, .y)
)

# Join the list elements together
# Naming of columns seems odd when you add more joins, have done this inelegantly
hierarchy_flat <- hier_list[[1]] %>% 
  left_join(hier_list[[2]], by = c("chr" = "chr0")) %>% 
  left_join(hier_list[[3]], by = c("chr.y" = "chr0")) %>% 
  left_join(hier_list[[4]], by = c("chr.y.y" = "chr0")) %>% 
  left_join(hier_list[[5]], by = c("chr" = "chr0")) %>% 
  rename(
    level0 = chr0,
    level1 = chr.x,
    level2 = chr.y,
    level3 = chr.y.y,
    level4 = chr,
    level5 = chr.y.y.y
  ) %>% 
  arrange(level0, level1, level2, level3, level4, level5)

# Write dataframe
# write_csv(hierarchy_flat, "output/hierarchy_flat.csv")


# Interactive visualisation -----------------------------------------------


tree <- collapsibleTree(
  hierarchy_flat,  # input data frame
  hierarchy = paste0("level", 1:5),  # columns containing hierarchy
  root = "GOV.UK",  # name for root node
  zoomable = FALSE,  # zoom in and out of the plot
  fill = "#005ea5"  # set to GOV.UK default for now
)


# Testing with a 'long' dataset -------------------------------------------


# 'Long data' (parent, node, attributes columns) also can be used to plot with
# (Bind the parent-child elements from the hier_list object). It uses the 
# collapsibleTreeNetwork() function rather than collapsibleTree() function.

hierarchy_long <- bind_rows(hier_list[1:3]) %>% 
  rename(parent = chr0, node = chr) %>% 
  mutate(test_attribute = abs(rnorm(nrow(.)))) %>% # made-up
  add_row(parent = NA, node = "GOV.UK", test_attribute = rnorm(1))  # root must have NA parent

# Write dataframe
# write_csv(hierarchy_long, "output/hierarchy_long.csv")

# Feed to visualisation

tree_attributes <- collapsibleTreeNetwork(
  hierarchy_long,
  attribute = "test_attribute"  # 
)  # Takes a very long time