rm(list = ls())

library(doParallel)

# Rscript tests/test_generateMissingVariantCountStackBarChartParallel.R

source("./R/generateMissingVariantCountStackBarChartParallel.R")


return_value <- generateMissingVariantCountStackBarChartParallel(
  bcftools_tab_delimited_file_path = c(
    file.path("/scratch/yenc/projects/VisualVariants/data/Nebraska.Chr01.txt"),
    file.path("/scratch/yenc/projects/VisualVariants/data/Nebraska.Chr02.txt"),
    file.path("/scratch/yenc/projects/VisualVariants/data/Nebraska.Chr03.txt")
  ),
  cores=3
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
