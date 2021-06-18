
# VisualVariants

<!-- badges: start -->
<!-- badges: end -->

The goal of this project is to create an R package and executable scripts to visualize variants in variant call format (VCF) files and bcftools tab-delimited files.

## Requirements

In order to run the VisualVariants, users need to install software, programming languages, and packages in their computing systems.
The software, programming languages, and packages include:

```
R>=3.6.0
``` 

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

1. generateMissingVariantCountStackBarChartParallel.R

```
Rscript scripts/generateMissingVariantCountStackBarChartParallel.R [-h] [--cores CORES] --inputs INPUTS --output OUTPUT [--all]

mandatory arguments:
  --inputs INPUTS       Input bcftools tab delimited files
  --output OUTPUT       Output file path

optional arguments:
  -h, --help            show this help message and exit
  --cores CORES         Number of processing cores
  --all                 Output all files
```

2. generateSampleMissingPercentageScatterPlotParallel.R

```
Rscript scripts/generateSampleMissingPercentageScatterPlotParallel.R [-h] [--cores CORES] --inputs INPUTS --output OUTPUT [--all]

mandatory arguments:
  --inputs INPUTS       Input bcftools tab delimited files
  --output OUTPUT       Output file path

optional arguments:
  -h, --help            show this help message and exit
  --cores CORES         Number of processing cores
  --all                 Output all files
```

3. generateVariantCountHistogramParallel.R

```
Rscript scripts/generateVariantCountHistogramParallel.R [-h] [--cores CORES] --inputs INPUTS --output OUTPUT [--gap GAP] [--binwidth BINWIDTH]

mandatory arguments:
  --inputs INPUTS       Input bcftools tab delimited files
  --output OUTPUT       Output file path

optional arguments:
  -h, --help            show this help message and exit
  --cores CORES         Number of processing cores
  --gap GAP             Gap of ticks in the x axis
  --binwidth BINWIDTH   Width of each bin for the histogram
```

## Examples

These are basic examples which show you how to use VisualVariants:

1. generateMissingVariantCountStackBarChartParallel.R

```
Rscript scripts/generateMissingVariantCountStackBarChartParallel.R \
--cores 3 \
--inputs /scratch/yenc/projects/VisualVariants/data/Nebraska.Chr01.txt \
--inputs /scratch/yenc/projects/VisualVariants/data/Nebraska.Chr02.txt \
--inputs /scratch/yenc/projects/VisualVariants/data/Nebraska.Chr03.txt \
--output /scratch/yenc/projects/VisualVariants/output/missing_variant_count_stack_bar_chart.png \
--all
```

2. generateSampleMissingPercentageScatterPlotParallel.R

```
Rscript scripts/generateSampleMissingPercentageScatterPlotParallel.R \
--cores 3 \
--inputs /scratch/yenc/projects/VisualVariants/data/Nebraska.Chr01.txt \
--inputs /scratch/yenc/projects/VisualVariants/data/Nebraska.Chr02.txt \
--inputs /scratch/yenc/projects/VisualVariants/data/Nebraska.Chr03.txt \
--output /scratch/yenc/projects/VisualVariants/output/sample_missing_percentage_scatter_plot.png \
--all
```

3. generateVariantCountHistogramParallel.R

```
Rscript scripts/generateVariantCountHistogramParallel.R \
--cores 3 \
--inputs /scratch/yenc/projects/VisualVariants/data/Nebraska.Chr01.txt \
--inputs /scratch/yenc/projects/VisualVariants/data/Nebraska.Chr02.txt \
--inputs /scratch/yenc/projects/VisualVariants/data/Nebraska.Chr03.txt \
--output /scratch/yenc/projects/VisualVariants/output/variant_count_histogram.png
```

## Results

These are basic examples which show you how to use VisualVariants:

1. generateMissingVariantCountStackBarChartParallel.R

![missing variant count stack bar chart](https://user-images.githubusercontent.com/22091525/104143512-667a9f00-5385-11eb-95cc-4ed2fa0396da.png)

2. generateSampleMissingPercentageScatterPlotParallel.R

![sample missing percentage scatter plot](https://user-images.githubusercontent.com/22091525/104143516-68dcf900-5385-11eb-9073-5dfb292d2cd7.png)

3. generateVariantCountHistogramParallel.R

![variant_count_histogram](https://user-images.githubusercontent.com/22091525/122620706-3d0f1f00-d059-11eb-8e0b-402c79a1bcb8.png)

## Package Update

To upgrade VisualVariants to the latest version, please remove the package and re-install the latest VisualVariants package:

``` r
# Run this inside R environment
remove.packages("VisualVariants")
devtools::install_github("yenon118/VisualVariants")
```
