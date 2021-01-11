
# VisualVariants

<!-- badges: start -->
<!-- badges: end -->

The goal of this project is to create an R package and executable scripts to visualize variants in variant call format (VCF) files and bcftools tab-delimited files.

## Installation

You can install the VisualVariants from [Github](https://github.com/yenon118/VisualVariants) with:

``` r
# Run this inside R environment
install.packages("devtools", dependencies = TRUE)
devtools::install_github("yenon118/VisualVariants")
```

``` 
# Run this in your terminal
git clone https://github.com/yenon118/VisualVariants.git
```

## Usage

```
Rscript scripts/generateMissingVariantCountStackBarChartParallel.R [-h] [--cores CORES] --inputs INPUTS --output OUTPUT [--all]

mandatory arguments:
  --inputs INPUTS  Input bcftools tab delimited files
  --output OUTPUT  Output file path

optional arguments:
  -h, --help       show this help message and exit
  --cores CORES    Number of processing cores
  --all            Output all files
```

```
Rscript scripts/generateSampleMissingPercentageScatterPlotParallel.R [-h] [--cores CORES] --inputs INPUTS --output OUTPUT [--all]

mandatory arguments:
  --inputs INPUTS  Input bcftools tab delimited files
  --output OUTPUT  Output file path

optional arguments:
  -h, --help       show this help message and exit
  --cores CORES    Number of processing cores
  --all            Output all files
```

## Example

This is a basic example which shows you how to use VisualVariants:

```
Rscript scripts/generateMissingVariantCountStackBarChartParallel.R \
--cores 3 \
--inputs /scratch/yenc/projects/VisualVariants/data/Nebraska.Chr01.txt \
--inputs /scratch/yenc/projects/VisualVariants/data/Nebraska.Chr02.txt \
--inputs /scratch/yenc/projects/VisualVariants/data/Nebraska.Chr03.txt \
--output /scratch/yenc/projects/VisualVariants/output/missing_variant_count_stack_bar_chart.png \
--all
```

```
Rscript scripts/generateSampleMissingPercentageScatterPlotParallel.R \
--cores 3 \
--inputs /scratch/yenc/projects/VisualVariants/data/Nebraska.Chr01.txt \
--inputs /scratch/yenc/projects/VisualVariants/data/Nebraska.Chr02.txt \
--inputs /scratch/yenc/projects/VisualVariants/data/Nebraska.Chr03.txt \
--output /scratch/yenc/projects/VisualVariants/output/sample_missing_percentage_scatter_plot.png \
--all
```

## Package Update

To upgrade VisualVariants to the latest version, please remove the package and re-install the latest VisualVariants package:

``` r
# Run this inside R environment
remove.packages("VisualVariants")
devtools::install_github("yenon118/VisualVariants")
```
