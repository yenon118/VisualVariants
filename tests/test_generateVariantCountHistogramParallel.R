rm(list = ls())

library(doParallel)

# Rscript tests/test_generateVariantCountHistogramParallel.R

source("./R/generateVariantCountHistogramParallel.R")


return_value <- generateVariantCountHistogramParallel(
  bcftools_tab_delimited_file_path = c(
    file.path("/scratch/yenc/projects/VisualVariants/data/Nebraska.Chr01.txt"),
    file.path("/scratch/yenc/projects/VisualVariants/data/Nebraska.Chr02.txt"),
    file.path("/scratch/yenc/projects/VisualVariants/data/Nebraska.Chr03.txt")
  ),
  cores=3,
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
