#' Create a variant count histogram
#'
#' @description
#' The goal of generateVariantCountHistogramParallel is to create
#' a variant count histogram for a bcftools processed input tab
#' delimited file.
#' @importFrom foreach %dopar%
#' @importFrom magrittr %>%
#' @param bcftools_tab_delimited_file_paths File paths of bcftools tab delimited files.
#' @param cores The number of cores used to process data.
#' @param gap The gap of ticks in the x axis.
#' @param binwidth The width of each bin for the histogram.
#' @return variant count histogram.
#' @keywords variant_count
#' @example generateVariantCountHistogramParallel(c(file.path("data/Nebraska.Chr01.txt"),file.path("data/Nebraska.Chr02.txt")),3,1,1e5)
#' @export
#'
generateVariantCountHistogramParallel <- function (bcftools_tab_delimited_file_paths, cores=1, gap=5, binwidth=1e5){

  ##################################################
  # Register processing cores
  ##################################################
  doParallel::registerDoParallel(cores = cores)

  ##################################################
  # Check input file exist or not
  # If the input file does not exists, return null.
  ##################################################
  bcftools_tab_delimited_file_paths <- foreach(i=1:length(bcftools_tab_delimited_file_paths), .combine = c) %dopar% {
    if(!file.exists(bcftools_tab_delimited_file_paths[i])){
      cat("Input file does not exist!!!")
      return(NULL)
    } else{
      return(normalizePath(bcftools_tab_delimited_file_paths[i]))
    }
  }

  bcftools_tab_delimited_file_paths <- bcftools_tab_delimited_file_paths[!is.null(bcftools_tab_delimited_file_paths)]

  if(length(bcftools_tab_delimited_file_paths) == 0){
    return(NULL)
  }

  df <- foreach(i=1:length(bcftools_tab_delimited_file_paths), .combine = rbind) %dopar% {

    ##################################################
    # Read data frame
    ##################################################
    dat <- read.table(
      file = file.path(bcftools_tab_delimited_file_paths[i]),
      header = TRUE,
      sep = "\t",
      stringsAsFactors = FALSE,
      check.names = FALSE,
      comment.char = ""
    )

    return(
      data.frame(
        CHROM = dat[,1],
        POS = dat[,2],
        stringsAsFactors = FALSE
      )
    )

  }

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
  # Detach all cores
  ##################################################
  doParallel::stopImplicitCluster()

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