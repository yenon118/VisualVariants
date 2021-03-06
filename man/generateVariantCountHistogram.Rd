% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/generateVariantCountHistogram.R
\name{generateVariantCountHistogram}
\alias{generateVariantCountHistogram}
\title{Create a variant count histogram}
\usage{
generateVariantCountHistogram(
  bcftools_tab_delimited_file_path,
  gap = 5,
  binwidth = 1e+05
)
}
\arguments{
\item{bcftools_tab_delimited_file_path}{A file path of bcftools tab delimited file.}

\item{gap}{The gap of ticks in the x axis.}

\item{binwidth}{The width of each bin for the histogram.}
}
\value{
variant count histogram.
}
\description{
The goal of generateVariantCountHistogram is to create
a variant count histogram for a bcftools processed
input tab delimited file.
}
\keyword{variant_count}
