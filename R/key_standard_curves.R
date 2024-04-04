#' A data dictionary linking experiment names to standard curve data
#'
#' These data serve as a key to cross reference between each unique experiment name to the appropriate standard curve data.
#' @format ## `key_standard_curves`
#' A data frame with 3 columns:
#' \describe{
#'   \item{experiment_date}{The date the experiment was run.}
#'   \item{experiment_name}{The name of the experiment (e.g. ES BEED TAC CARD 001, QADRI ENTERIC CARD 121).}
#'   \item{standard_curve_file_name}{The standard curve file name that is associated with the given experiment name.}
#' }
"key_standard_curves"
