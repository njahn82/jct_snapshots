# Gather Transformative Agreement Public Data 
pkgload::load_all()
# Overview
jct_overview <- jct_overview()
# Get data per agreement
jct_req <- 
  purrr::map2(jct_overview$esac_id[1:10], 
              jct_overview$data_url[1:10],
              purrr::safely(jct_fetch)
              )
# Save
path <- paste0(here::here("data-raw"), "/", Sys.Date())
fs::dir_create(path)
# Save journal data
purrr::map(jct_req, "result") |>
  purrr::map_df("jn_df") |>
  readr::write_csv(paste0(path, "/jct_journals.csv"))
# Save inst data
inst_df <- purrr::map(jct_req, "result") |>
  purrr::map_df("inst_df") |>
  readr::write_csv(paste0(path, "/jct_institutions.csv"))

# ESAC
esac_fetch() |>
  readr::write_csv(paste0(path, "/esac_registry.csv"))

