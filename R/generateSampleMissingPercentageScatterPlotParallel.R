#' Create missing percentage scatter plot for samples in bcftools tab delimited file
#'
#' @description
#' The goal of generateSampleMissingPercentageScatterPlotParallel is to create
#' a missing percentage scatter plot for samples in bcftools tab delimited file.
#' @importFrom foreach %dopar%
#' @importFrom magrittr %>%
#' @param bcftools_tab_delimited_file_paths File paths of bcftools tab delimited files.
#' @param cores The number of cores used to process data.
#' @return sample missing percentage scatter plot.
#' @keywords sample_missing_percentage_scatter_plot
#' @example generateSampleMissingPercentageScatterPlotParallel(c(file.path("data/Nebraska.Chr01.txt"),file.path("data/Nebraska.Chr02.txt")),3)
#' @export
#'
generateSampleMissingPercentageScatterPlotParallel <- function (bcftools_tab_delimited_file_paths, cores=1){

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

  missing_df<- foreach(i=1:length(bcftools_tab_delimited_file_paths), .combine = rbind) %dopar% {

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

    return(
      data.frame(
        CHROM = dat[1,1],
        LINE = colnames(dat)[5:ncol(dat)],
        Missing = missing,
        Total = nrow(dat),
        stringsAsFactors = FALSE
      )
    )

  }

  ##################################################
  # Calculate missing percentage
  ##################################################
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
  # Detach all cores
  ##################################################
  doParallel::stopImplicitCluster()

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
