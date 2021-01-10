rm(list = ls())

library(doParallel)

# Rscript tests/test_generateSampleMissingPercentageScatterPlotParallel.R

source("./R/generateSampleMissingPercentageScatterPlotParallel.R")


return_value <- generateSampleMissingPercentageScatterPlotParallel(
  bcftools_tab_delimited_file_path = c(
    file.path("/scratch/yenc/projects/VisualVariants/data/Nebraska.Chr01.txt"),
    file.path("/scratch/yenc/projects/VisualVariants/data/Nebraska.Chr02.txt"),
    file.path("/scratch/yenc/projects/VisualVariants/data/Nebraska.Chr03.txt")
  ),
  cores=3
)

print(head(return_value$SampleMissingPercentageDataFrame))
print(head(return_value$SampleMissingPercentageCountDataFrame))

ggplot2::ggsave(
  filename = file.path("sample_missing_percentage_scatter_plot.png"),
  plot = return_value$SampleMissingPercentageScatterPlot,
  path = file.path("./output"),
  width = 32,
  height = 18,
  dpi = 800
)
