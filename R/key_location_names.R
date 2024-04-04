#' A data dictionary for location names
#'
#' These data serve as a key to cross reference the unique (and sometimes duplicated) location names of sampling sites
#' and a set of 'concise' names that clean up characters and allow combination of duplicated locations.
#'
#' @format ## `key_location_names`
#' A data frame with 2 columns:
#' \describe{
#'   \item{location_name_unique}{Original location name.}
#'   \item{location_name_concise}{The associated concise location name with typos and duplicates removed.}
#' }
"key_location_names"
