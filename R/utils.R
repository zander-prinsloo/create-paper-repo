.normalize_project_path <- function(path, must_exist = FALSE) {
  if (length(path) != 1L || !is.character(path) || is.na(path)) {
    stop("path must be a single, non-missing character string.", call. = FALSE)
  }

  path <- path.expand(path)
  if (must_exist && !dir.exists(path)) {
    stop("Project directory does not exist: ", path, call. = FALSE)
  }
  normalizePath(path, winslash = "/", mustWork = FALSE)
}

.template_root <- function() {
  installed <- system.file("templates", "paper-project", package = "paperrepo")
  if (nzchar(installed) && dir.exists(installed)) {
    return(installed)
  }

  development <- file.path("inst", "templates", "paper-project")
  if (dir.exists(development)) {
    return(normalizePath(development, winslash = "/", mustWork = TRUE))
  }

  stop("Could not locate the paper-project template.", call. = FALSE)
}

.slugify <- function(x) {
  x <- tolower(trimws(as.character(x)))
  x <- gsub("[^a-z0-9]+", "-", x)
  x <- gsub("(^-+|-+$)", "", x)
  if (!nzchar(x)) "note" else x
}

.write_text <- function(path, text) {
  dir.create(dirname(path), recursive = TRUE, showWarnings = FALSE)
  writeLines(enc2utf8(text), path, useBytes = TRUE)
  invisible(path)
}

.replace_tokens <- function(text, tokens) {
  for (token in names(tokens)) {
    text <- gsub(
      paste0("{{", token, "}}"),
      as.character(tokens[[token]]),
      text,
      fixed = TRUE
    )
  }
  text
}

.initialize_renv <- function(path, quiet = FALSE) {
  if (!requireNamespace("renv", quietly = TRUE)) {
    warning(
      "The scaffold includes renv files, but the renv package is not installed. ",
      "Run install.packages('renv') and then renv::init('",
      path,
      "', bare = TRUE).",
      call. = FALSE
    )
    return("deferred")
  }

  tryCatch(
    {
      renv::init(project = path, bare = TRUE, quiet = quiet)
      tryCatch(
        renv::snapshot(project = path, prompt = FALSE),
        error = function(error) {
          warning(
            "renv was initialized, but the initial snapshot could not be written: ",
            conditionMessage(error),
            call. = FALSE
          )
          invisible(NULL)
        }
      )
      "initialized"
    },
    error = function(error) {
      warning(
        "The project was created, but renv could not be initialized: ",
        conditionMessage(error),
        call. = FALSE
      )
      "deferred"
    }
  )
}
