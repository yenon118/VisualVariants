#' Create a missing variant count stack bar chart
#'
#' @description
#' The goal of generateMissingVariantCountStackBarChartParallel is to create
#' a missing variant count stack bar chart for a bcftools processed
#' input tab delimited file.
#' @importFrom foreach %dopar%
#' @importFrom magrittr %>%
#' @param bcftools_tab_delimited_file_paths File paths of bcftools tab delimited files.
#' @param cores The number of cores used to process data.
#' @return missing variant count stack bar chart.
#' @keywords non_missing_variants
#' @example generateMissingVariantCountStackBarChartParallel(c(file.path("data/Nebraska.Chr01.txt"),file.path("data/Nebraska.Chr02.txt")),3)
#' @export
#'
generateMissingVariantCountStackBarChartParallel <- function (bcftools_tab_delimited_file_paths, cores=1){

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

  missing_df <- foreach(i=1:length(bcftools_tab_delimited_file_paths), .combine = rbind) %dopar% {

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
    missing <- as.integer(apply(dat[, 5:ncol(dat)], 1, function(x) { return(length(x[x == "./."])) }))

    return(
      data.frame(
        CHROM = dat[,1],
        POS = dat[,2],
        REF = dat[,3],
        ALT = dat[,4],
        Missing = missing,
        Total = ncol(dat)-4,
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
  missing_percentage_per_chromosome <- dplyr::group_by(.data=missing_df, CHROM, Missing_percentage)
  missing_percentage_per_chromosome <- dplyr::summarize(.data=missing_percentage_per_chromosome, Count=dplyr::n())
  missing_percentage_per_chromosome <- dplyr::arrange(.data=missing_percentage_per_chromosome, CHROM, desc(Missing_percentage))
  missing_percentage_per_chromosome <- as.data.frame(missing_percentage_per_chromosome, stringsAsFactors=FALSE)

  ##################################################
  # Plot missing variant count stack bar chart
  ##################################################
  p <- ggplot2::ggplot(data = missing_percentage_per_chromosome, mapping = ggplot2::aes(x = factor(Missing_percentage), y = Count, fill = factor(CHROM))) +
    ggplot2::geom_bar(stat="identity", color="black") +
    ggplot2::labs(title = "Number of Missing Percentage for Positions in Each Chromosome",
                  y = "Count",
                  x = "Missing Percentage \n (for each x in integer range [0,100): >= x and < x+1)") +
    ggplot2::scale_fill_discrete(name = "Chromosome") +
    ggplot2::theme_classic() +
    ggplot2::theme(
      plot.title = ggplot2::element_text(size = 40, hjust = 0.5, face = "bold"),
      axis.title = ggplot2::element_text(size = 28),
      axis.text.y = ggplot2::element_text(size = 24),
      axis.text.x = ggplot2::element_text(size = 16),
      legend.title = ggplot2::element_text(size = 24),
      legend.text = ggplot2::element_text(size = 24)
    )

  ##################################################
  # Detach all cores
  ##################################################
  doParallel::stopImplicitCluster()

  ##################################################
  # Check and return results
  ##################################################
  if(exists("missing_df") & exists("missing_percentage_per_chromosome") & exists("p")){
    if(!is.null(missing_df) & !is.null(missing_percentage_per_chromosome) & !is.null(p)){
      list(
        "MissingVariantDataFrame" = missing_df,
        "MissingVariantCountDataFrame" = missing_percentage_per_chromosome,
        "MissingVariantCountStackBarChart" = p
      )
    } else{
      return(NULL)
    }
  } else{
    return(NULL)
  }
}
