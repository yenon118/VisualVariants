rm(list = ls())

# Rscript tests/test_generateSampleMissingPercentageScatterPlot.R

source("./R/generateSampleMissingPercentageScatterPlot.R")


return_value <- generateSampleMissingPercentageScatterPlot(
  bcftools_tab_delimited_file_path = file.path("/scratch/yenc/projects/VisualVariants/data/Nebraska.subset.txt")
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
