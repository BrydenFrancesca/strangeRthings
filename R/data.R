#' A transcript of all Stranger Things episodes
#'
#' Each season consists of episodes, each episode is divided into utterances.
#' One utterance per row.
#' Where available, the character speaking the utterance is included.
#'
#' @source \url{https://subslikescript.com/}
#'
#' @format A [tibble][tibble::tibble-package] with `r nrow(stranger_text)` rows and
#'   `r ncol(stranger_text)` variables:
#' \code{utterance}, \code{episode_name}, \code{season}, \code{episode_number},
#' and \code{character}.
"stranger_text"
