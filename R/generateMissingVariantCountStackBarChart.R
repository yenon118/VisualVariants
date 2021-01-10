#' Create a missing variant count stack bar chart
#'
#' @description
#' The goal of generateMissingVariantCountStackBarChart is to create
#' a missing variant count stack bar chart for a bcftools processed
#' input tab delimited file.
#' @importFrom foreach %dopar%
#' @importFrom magrittr %>%
#' @param bcftools_tab_delimited_file_path A file path of bcftools tab delimited file.
#' @return missing variant count stack bar chart.
#' @keywords non_missing_variants
#' @example generateMissingVariantCountStackBarChart("data/Nebraska.subset.txt")
#' @export
#'
generateMissingVariantCountStackBarChart <- function (bcftools_tab_delimited_file_path){

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
  missing <- as.integer(apply(dat[, 5:ncol(dat)], 1, function(x) { return(length(x[x == "./."])) }))

  missing_df <- data.frame(
    CHROM = dat[,1],
    POS = dat[,2],
    REF = dat[,3],
    ALT = dat[,4],
    Missing = missing,
    Total = ncol(dat)-4,
    stringsAsFactors = FALSE
  )

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
