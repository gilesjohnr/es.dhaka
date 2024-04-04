#' Standard curve data for Dhaka analyses
#'
#' These data provide the standard curve relationship between viral load and the qPCR Ct value. The data pertain only to analyses
#' run for samples from Dhaka, Bangladesh. However, the format of these data can be replicated when modeling viral load for other data sources.
#'
#' @format ## `standard_curves`
#' A data frame with 4 columns:
#' \describe{
#'   \item{target_name_unique}{The original target name found on each of the taqman array cards. May contain typos and duplicates.}
#'   \item{target_name_concise}{The associated concise target name with typos and duplicates removed.}
#'   \item{ct_value}{The Ct value attained for the particular viral load dilution. If more than one Ct value was produced for a
#'   particular card design, then the mean in log space is taken.}
#'   \item{quantity}{The number of viral copies for the particular dilution.}
#' }
"standard_curves"
