#!/usr/bin/env Rscript

rm(list = ls())

# Rscript scripts/generateVariantCountHistogramParallel.R \
# --cores 3 \
# --inputs /scratch/yenc/projects/VisualVariants/data/Nebraska.Chr01.txt \
# --inputs /scratch/yenc/projects/VisualVariants/data/Nebraska.Chr02.txt \
# --inputs /scratch/yenc/projects/VisualVariants/data/Nebraska.Chr03.txt \
# --output /scratch/yenc/projects/VisualVariants/output/variant_count_histogram.png

library(foreach)
library(iterators)
library(parallel)
library(doParallel)
library(VisualVariants)


parser <- argparse::ArgumentParser()

parser$add_argument("--cores", type="integer", default=1, help="Number of processing cores")

parser$add_argument("--inputs", type="character", action="append", help="Input bcftools tab delimited files", required=TRUE)
parser$add_argument("--output", type="character", help="Output file path", required=TRUE)

parser$add_argument("--gap", type="integer", default=10, help="Gap of ticks in the x axis")
parser$add_argument("--binwidth", type="double", default=1e5, help="Width of each bin for the histogram")

args <- parser$parse_args()


cores <- args$cores
inputs <- args$inputs
output <- args$output
gap <- args$gap
binwidth <- args$binwidth


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


return_value <- generateVariantCountHistogramParallel(
  bcftools_tab_delimited_file_path=inputs,
  cores=cores,
  gap=gap,
  binwidth=binwidth
)


ggplot2::ggsave(
  filename = basename(output),
  plot = return_value$VariantCountHistogram,
  path = dirname(output),
  width = 32,
  height = 18
)
