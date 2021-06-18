rm(list = ls())

# Rscript tests/test_generateVariantCountHistogram.R

source("./R/generateVariantCountHistogram.R")


return_value <- generateVariantCountHistogram(
  bcftools_tab_delimited_file_path = file.path("/scratch/yenc/projects/VisualVariants/data/Nebraska.subset.txt"),
  gap = 10,
  binwidth = 1e5
)

ggplot2::ggsave(
  filename = file.path("variant_count_histogram.png"),
  plot = return_value$VariantCountHistogram,
  path = file.path("./output"),
  width = 18,
  height = 10
)
