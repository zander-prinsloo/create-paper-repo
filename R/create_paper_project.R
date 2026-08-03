#' Create a reproducible empirical paper project
#'
#' Creates a Quarto-first project with conventional locations for data,
#' analysis code, exploratory work, research notes, manuscript outputs, and
#' reproducibility metadata. Existing files are never removed.
#'
#' @param path Directory to create. It may be a new directory.
#' @param project_name Human-readable title used in the generated files. If
#'   omitted, the directory name is used.
#' @param overwrite Whether existing template files may be replaced. This does
#'   not remove files that are not part of the scaffold.
#' @param init_renv Whether to initialize renv after writing the scaffold.
#'   Initialization is deferred with a warning when renv is not installed.
#' @param quiet Whether renv should suppress its progress output.
#'
#' @return An object of class "paper_project" containing the project path,
#'   created files, and renv initialization status.
#' @export
create_paper_project <- function(
    path = ".",
    project_name = NULL,
    overwrite = FALSE,
    init_renv = TRUE,
    quiet = FALSE) {
  path <- .normalize_project_path(path)
  if (file.exists(path) && !dir.exists(path)) {
    stop("path points to a file, not a directory: ", path, call. = FALSE)
  }
  dir.create(path, recursive = TRUE, showWarnings = FALSE)

  existing <- list.files(path, all.files = TRUE, no.. = TRUE)
  if (length(existing) > 0L && !isTRUE(overwrite)) {
    stop(
      "The target directory is not empty. Use a new directory or set overwrite = TRUE.",
      call. = FALSE
    )
  }

  if (is.null(project_name)) {
    project_name <- basename(path)
  }
  if (length(project_name) != 1L || !is.character(project_name) ||
      is.na(project_name) || !nzchar(trimws(project_name))) {
    stop("project_name must be a single, non-empty character string.", call. = FALSE)
  }

  template_root <- .template_root()
  template_files <- list.files(
    template_root,
    pattern = "\\.template$",
    recursive = TRUE,
    all.files = TRUE,
    full.names = TRUE
  )
  if (length(template_files) == 0L) {
    stop("The paper-project template contains no files.", call. = FALSE)
  }

  tokens <- c(
    PROJECT_NAME = trimws(project_name),
    CREATED_DATE = as.character(Sys.Date()),
    R_VERSION = paste(R.version$major, R.version$minor, sep = ".")
  )
  created <- character()

  for (source in template_files) {
    relative <- substring(source, nchar(template_root) + 2L)
    destination_relative <- if (identical(relative, "gitignore.template")) {
      ".gitignore"
    } else {
      sub("\\.template$", "", relative)
    }
    destination <- file.path(path, destination_relative)
    if (file.exists(destination) && !isTRUE(overwrite)) {
      stop(
        "A scaffold file already exists: ", destination,
        ". Use overwrite = TRUE to replace template files.",
        call. = FALSE
      )
    }
    text <- readLines(source, warn = FALSE, encoding = "UTF-8")
    .write_text(destination, .replace_tokens(text, tokens))
    created <- c(created, destination)
  }

  renv_status <- if (isTRUE(init_renv)) {
    .initialize_renv(path, quiet = quiet)
  } else {
    "template-only"
  }

  structure(
    list(
      path = path,
      project_name = trimws(project_name),
      files = created,
      renv = renv_status
    ),
    class = "paper_project"
  )
}
