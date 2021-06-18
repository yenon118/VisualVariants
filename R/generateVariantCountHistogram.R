#' Create a variant count histogram
#'
#' @description
#' The goal of generateVariantCountHistogram is to create
#' a variant count histogram for a bcftools processed
#' input tab delimited file.
#' @importFrom foreach %dopar%
#' @importFrom magrittr %>%
#' @param bcftools_tab_delimited_file_path A file path of bcftools tab delimited file.
#' @param gap The gap of ticks in the x axis.
#' @param binwidth The width of each bin for the histogram.
#' @return variant count histogram.
#' @keywords variant_count
#' @example generateVariantCountHistogram("data/Nebraska.subset.txt",5,1e5)
#' @export
#'
generateVariantCountHistogram <- function (bcftools_tab_delimited_file_path, gap=5, binwidth=1e5){

  ##################################################
  # Check input file exist or not
  # If the input file does not exists, return null.
  ##################################################
  if(!file.exists(bcftools_tab_delimited_file_path)){
    cat("Input file does not exist!!!")
    return(NULL)
  } else{
    bcftools_tab_delimited_file_path <- normalizePath(bcftools_tab_delimited_file_path)
  }

  ##################################################
  # Read data frame
  ##################################################
  dat <- read.table(
    file = file.path(bcftools_tab_delimited_file_path),
    header = TRUE,
    sep = "\t",
    stringsAsFactors = FALSE,
    check.names = FALSE,
    comment.char = ""
  )

  df <- data.frame(
    CHROM = dat[,1],
    POS = dat[,2],
    stringsAsFactors = FALSE
  )

  ##################################################
  # Sort and check the data
  ##################################################
  df <- dplyr::arrange(.data = df, CHROM, POS)
  df <- dplyr::distinct(.data = df, CHROM, POS, .keep_all = FALSE)
  df <- as.data.frame(df, stringsAsFactors = FALSE)

  ##################################################
  # Plot variant count histogram
  ##################################################
  p <- ggplot2::ggplot(df, ggplot2::aes(x=POS)) +
    ggplot2::geom_histogram(binwidth = binwidth) +
    ggplot2::scale_x_continuous(
      breaks = seq(0, max(df$POS), gap*binwidth),
      labels = seq(0, as.integer(max(df$POS)/binwidth), gap),
      guide = ggplot2::guide_axis(check.overlap = TRUE)
    ) +
    ggplot2::labs(title = "Variant Count Histogram", y = "Count", x = paste0("Position (*", binwidth, ")")) +
    ggplot2::facet_grid(CHROM ~ .) +
    ggplot2::theme(
      plot.title = ggplot2::element_text(hjust = 0.5, face = "bold")
    )

  ##################################################
  # Check and return results
  ##################################################
  if(exists("p")){
    if(!is.null(p)){
      list(
        "VariantCountHistogram" = p
      )
    } else{
      return(NULL)
    }
  } else{
    return(NULL)
  }
}
