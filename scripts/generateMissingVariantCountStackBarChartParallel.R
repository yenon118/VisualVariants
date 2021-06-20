#!/usr/bin/env Rscript

rm(list = ls())

# Rscript scripts/generateMissingVariantCountStackBarChartParallel.R \
# --cores 3 \
# --inputs /scratch/yenc/projects/VisualVariants/data/Nebraska.Chr01.txt \
# --inputs /scratch/yenc/projects/VisualVariants/data/Nebraska.Chr02.txt \
# --inputs /scratch/yenc/projects/VisualVariants/data/Nebraska.Chr03.txt \
# --output /scratch/yenc/projects/VisualVariants/output/missing_variant_count_stack_bar_chart.png \
# --all

library(foreach)
library(iterators)
library(parallel)
library(doParallel)
library(VisualVariants)


parser <- argparse::ArgumentParser()

parser$add_argument("--cores", type="integer", default=1, help="Number of processing cores")

parser$add_argument("--inputs", type="character", action="append", help="Input bcftools tab delimited files", required=TRUE)
parser$add_argument("--output", type="character", help="Output file path", required=TRUE)

parser$add_argument("--all", action="store_true", default=FALSE, help="Output all files")

args <- parser$parse_args()


cores <- args$cores
inputs <- args$inputs
output <- args$output
all <- args$all


for(i in 1:length(inputs)){
  if(!file.exists(inputs[i])){
    quit(status=1)
  }
}


if(!dir.exists(dirname(output))){
  dir.create(dirname(output), showWarnings=FALSE, recursive=TRUE)
  if(!dir.exists(dirname(output))){
    quit(status=1)
  }
}


return_value <- generateMissingVariantCountStackBarChartParallel(
  bcftools_tab_delimited_file_path=inputs,
  cores=cores
)


if(all == TRUE){
  utils::write.csv(
    x=return_value$MissingVariantDataFrame,
    file=file.path(gsub("(\\.png)$|(\\.jpg)$|(\\.jpeg)$", ".MissingVariantDataFrame.csv", output, ignore.case=TRUE)),
    row.names=FALSE,
    na=""
  )

  utils::write.csv(
    x=return_value$MissingVariantCountDataFrame,
    file=file.path(gsub("(\\.png)|(\\.jpg)|(\\.jpeg)", ".MissingVariantCountDataFrame.csv", output, ignore.case=TRUE)),
    row.names=FALSE,
    na=""
  )
}


ggplot2::ggsave(
  filename = basename(output),
  plot = return_value$MissingVariantCountStackBarChart,
  path = dirname(output),
  width = 32,
  height = 18
)
