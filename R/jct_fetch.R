#' Helper function to retrieve and parse Transformative Agreement Data
#'
#' @param esac_id Transformative Agreement ID issued by ESAC
#' @param data_url URL to Google Spreadsheet
#' 
#' @importFrom dplyr select mutate filter
#' @importFrom readr read_csv
#' @importFrom janitor clean_names
#' @importFrom rlang .data 
#' @export
jct_fetch <- function(esac_id = NULL, data_url = NULL) {
  # Progress
  message(paste("Fetching:", esac_id, "from", data_url))
  # Download spreadsheet
  req <- readr::read_csv(
    data_url,
    col_types = "cccccccc",
    show_col_types = FALSE,
    progress = FALSE
  )
  
  # Journal-level data
  jn_df <- req |>
    dplyr::select(
      journal_name = 1,
      issn_print = 2,
      issn_online = 3,
      first_seen = 4,
      last_seen = 5
    ) |>
    dplyr::filter(!is.na(.data$journal_name)) |>
    dplyr::mutate(esac_id = esac_id)
  
  # Institutional-level data
  inst_df <- req |>
    dplyr::select(
      inst_name = 6,
      ror_id = 7,
      inst_first_seen = 8,
      inst_last_seen = 9
    ) |>
    dplyr::filter(!is.na(.data$inst_name)) |>
    dplyr::mutate(esac_id = esac_id)
  
  # Return
  list(jn_df = jn_df, inst_df = inst_df)
}

jct_overview <- function(data_url = jct_url()) {
  readr::read_csv(data_url) |>
    janitor::clean_names()
}


jct_url <-
  function()
    "https://docs.google.com/spreadsheets/d/e/2PACX-1vStezELi7qnKcyE8OiO2OYx2kqQDOnNsDX1JfAsK487n2uB_Dve5iDTwhUFfJ7eFPDhEjkfhXhqVTGw/pub?gid=1130349201&single=true&output=csv"

#' Get ESAC Data
#' 
#' @param data_url URL of ESAC registry dump
#' 
#' @importFrom readxl read_xlsx
#' @importFrom janitor clean_names
#' @importFrom utils download.file
esac_fetch <- function(data_url = "https://keeper.mpdl.mpg.de/f/7fbb5edd24ab4c5ca157/?dl=1") {
  tmp <- tempfile()
  download.file(data_url, tmp)
  readxl::read_xlsx(tmp, skip = 2) |>
    janitor::clean_names()
}
