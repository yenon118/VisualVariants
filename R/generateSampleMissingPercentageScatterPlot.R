#' Create missing percentage scatter plot for samples in bcftools tab delimited file
#'
#' @description
#' The goal of generateSampleMissingPercentageScatterPlot is to create
#' a missing percentage scatter plot for samples in bcftools tab delimited file.
#' @importFrom foreach %dopar%
#' @importFrom magrittr %>%
#' @param bcftools_tab_delimited_file_path A file path of bcftools tab delimited file.
#' @return sample missing percentage scatter plot.
#' @keywords sample_missing_percentage_scatter_plot
#' @example generateSampleMissingPercentageScatterPlot("data/Nebraska.subset.txt")
#' @export
#'
generateSampleMissingPercentageScatterPlot <- function (bcftools_tab_delimited_file_path){

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

  ##################################################
  # Clean header
  # Remove square brackets and anything inside
  # Remove ":GT"
  ##################################################
  colnames(dat) <- gsub("(.*\\[)|(.*\\])|(:GT)", "", colnames(dat))

  ##################################################
  # Get number of missing values in each position
  # Then create a data frame to kepp all information
  ##################################################
  missing <- as.integer(apply(dat[, 5:ncol(dat)], 2, function(x) { return(length(x[x == "./."])) }))

  missing_df <- data.frame(
    CHROM = dat[1,1],
    LINE = colnames(dat)[5:ncol(dat)],
    Missing = missing,
    Total = nrow(dat),
    stringsAsFactors = FALSE
  )

  missing_df$Missing_percentage <- as.integer(100 * (missing_df$Missing / missing_df$Total))

  ##################################################
  # Summarize missing percentages and counts
  ##################################################
  missing_percentage_per_line <- dplyr::group_by(.data=missing_df, LINE)
  missing_percentage_per_line <- dplyr::summarize(.data=missing_percentage_per_line, Missing = sum(Missing, na.rm = TRUE), Total = sum(Total, na.rm = TRUE))
  missing_percentage_per_line <- dplyr::mutate(.data=missing_percentage_per_line, Missing_percentage = 100 * (Missing / Total))
  missing_percentage_per_line <- dplyr::arrange(.data=missing_percentage_per_line, desc(Missing_percentage))
  missing_percentage_per_line <- as.data.frame(missing_percentage_per_line, stringsAsFactors=FALSE)

  ##################################################
  # Plot sample missing percentage scatter plot
  ##################################################
  p <- ggplot2::ggplot(data = missing_percentage_per_line, mapping = ggplot2::aes(x = LINE, y = Missing_percentage)) +
    ggplot2::geom_point() +
    ggplot2::labs(x = "Lines", y = "Missing Percentage", title = "Missing Percentage for Each Line", caption = missing_percentage_per_line$Total[1]) +
    ggplot2::theme(
      plot.title = ggplot2::element_text(size = 40, hjust = 0.5, face = "bold"),
      axis.title = ggplot2::element_text(size = 28),
      axis.text.y = ggplot2::element_text(size = 24),
      axis.text.x = ggplot2::element_text(angle = 90, size = 4)
    )

  ##################################################
  # Check and return results
  ##################################################
  if(exists("missing_df") & exists("missing_percentage_per_line") & exists("p")){
    if(!is.null(missing_df) & !is.null(missing_percentage_per_line) & !is.null(p)){
      list(
        "SampleMissingPercentageDataFrame" = missing_df,
        "SampleMissingPercentageCountDataFrame" = missing_percentage_per_line,
        "SampleMissingPercentageScatterPlot" = p
      )
    } else{
      return(NULL)
    }
  } else{
    return(NULL)
  }
}
