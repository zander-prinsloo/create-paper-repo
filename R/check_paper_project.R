#' Check the structure of a paper project
#'
#' Checks that the generated project contains the folders and files needed for
#' the paperrepo workflow.
#'
#' @param path Path to a paper project.
#'
#' @return An object of class "paper_project_check" with one row per required
#' path and a logical present field.
#' @export
check_paper_project <- function(path = ".") {
  path <- .normalize_project_path(path, must_exist = TRUE)
  required <- c(
    "README.md",
    "_quarto.yml",
    "paper.qmd",
    "paper.tex",
    "data",
    "data/raw",
    "data/processed",
    "R",
    "code",
    "sandbox",
    "notes",
    "notes/active.md",
    "notes/INDEX.md",
    "notes/archive",
    "output",
    "output/manuscript",
    "output/results",
    "output/tables",
    "output/figures",
    "scripts",
    "scripts/run-analysis.R",
    "scripts/render-paper.R",
    "renv",
    "renv.lock"
  )
  full_paths <- file.path(path, required)
  present <- file.exists(full_paths) | dir.exists(full_paths)
  result <- data.frame(
    path = required,
    present = present,
    stringsAsFactors = FALSE,
    row.names = NULL
  )
  structure(
    list(
      path = path,
      files = result,
      ok = all(result$present)
    ),
    class = "paper_project_check"
  )
}

#' @export
print.paper_project_check <- function(x, ...) {
  status <- if (isTRUE(x$ok)) "PASS" else "INCOMPLETE"
  cat("paperrepo project check: ", status, "\n", sep = "")
  missing <- x$files$path[!x$files$present]
  if (length(missing) > 0L) {
    cat("Missing:\n")
    cat(paste0("  - ", missing, collapse = "\n"), "\n", sep = "")
  } else {
    cat("All required project paths are present.\n")
  }
  invisible(x)
}
