# {collapsibleTree} example
# https://adeelk93.github.io/collapsibleTree/

library(collapsibleTree)
library(readr)
library(tidyr)
library(dplyr)

tax_hierarchy_tree <- function(
  hierarchy_data_path, y_size = 1000, x_size = 2000, ...
  ) {
  
  hierarchy <- read_csv(
    hierarchy_data_path,
    col_names = paste0("level", 0:5)
  )
  
  hierarchy_fill <- hierarchy %>% 
    fill(level0, level1) %>% 
    group_by(level2) %>% fill(level3) %>% ungroup() %>% 
    group_by(level3) %>% fill(level4) %>% ungroup() %>% 
    group_by(level4) %>% fill(level5) %>% ungroup()
  
  tree <- collapsibleTree(
    hierarchy_fill,
    hierarchy = paste0("level", 1:5),
    root = "GOV.UK",
    zoomable = FALSE,
    fill = "#005ea5",
    height = y_size,
    width = x_size
  )
  
  return(tree)
  
}

tax_hierarchy_tree("data/20190711_hierarchy.csv")
