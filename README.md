# govuk-taxonomy-viz

## Purpose

This repo is for visualising the GOV.UK taxonomy. The aim is to aid colleagues with exploring the hierarchy.

There are [many ways to display hierarchical data](https://observablehq.com/collection/@d3/d3-hierarchy), including trees/dendrograms, treemaps, icicles, sunbursts and circlepacking.

## Tree

The tree has been embedded in a flexdashboard. There are two tabs: one with the tree and one with information.

You can click the nodes on the [interactive tree diagram](https://ukgovdatascience.github.io/govuk-taxonomy-viz/20190712_taxonomy-hierarchy-tree.html) to expand them to the next level. Filled nodes can be expanded; white nodes do not have any children and can't be expanded further.

![Static image of the interactive tree diagram](img/tree.png)

You can render the flexdashboard R Markdown file with:

```{r}
rmarkdown::render(
  input = "02_taxonomy-flexdashboard.Rmd",  # fiel containing the flexdashboard
  output_format = "flex_dashboard",  # output format is a flexdashboard
  output_dir = "docs",  # output directory
  output_file = "doc_name.html"  # output filename (change this as necessary)
)
```