rm(list = ls())

# Rscript tests/test_generateMissingVariantCountStackBarChart.R

source("./R/generateMissingVariantCountStackBarChart.R")


return_value <- generateMissingVariantCountStackBarChart(
  bcftools_tab_delimited_file_path = file.path("/scratch/yenc/projects/VisualVariants/data/Nebraska.subset.txt")
)

print(head(return_value$MissingVariantDataFrame))
print(head(return_value$MissingVariantCountDataFrame))

ggplot2::ggsave(
  filename = file.path("missing_variant_count_stack_bar_chart.png"),
  plot = return_value$MissingVariantCountStackBarChart,
  path = file.path("./output"),
  width = 32,
  height = 18,
  dpi = 800
)
