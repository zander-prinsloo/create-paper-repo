#' Render a paper with Quarto
#'
#' Renders the manuscript into HTML, Word, PDF, or all three formats. The
#' generated files are placed in output/manuscript/. When PDF is rendered,
#' the TeX file retained by Quarto is copied to paper.tex at the project
#' root for journal submission.
#'
#' @param path Path to a paper project.
#' @param formats Character vector containing any of "pdf", "docx", and
#'   "html", or the single value "all".
#' @param quarto Optional path to the Quarto executable. By default, the
#'   executable is located with Sys.which("quarto").
#' @param quiet Whether to capture Quarto output.
#'
#' @return An object of class "paperrepo_render" describing the rendered
#'   formats, output directory, and TeX handoff.
#' @examples
#' \dontrun{
#' render_paper("my-paper", formats = "all")
#' render_paper("my-paper", formats = c("pdf", "docx"))
#' }
#' @export
render_paper <- function(
    path = ".",
    formats = "all",
    quarto = NULL,
    quiet = FALSE) {
  path <- .normalize_project_path(path, must_exist = TRUE)
  qmd <- file.path(path, "paper.qmd")
  if (!file.exists(qmd)) {
    stop("Could not find paper.qmd in: ", path, call. = FALSE)
  }

  choices <- c("pdf", "docx", "html")
  if (length(formats) == 1L && identical(formats, "all")) {
    formats <- choices
    render_all <- TRUE
  } else {
    if (!is.character(formats) || length(formats) == 0L ||
        anyNA(formats) || any(!formats %in% choices)) {
      stop(
        "formats must be 'all' or a non-empty selection of: ",
        paste(choices, collapse = ", "),
        call. = FALSE
      )
    }
    formats <- unique(formats)
    render_all <- FALSE
  }

  if (is.null(quarto)) {
    quarto <- Sys.which("quarto")
  }
  if (length(quarto) != 1L || !nzchar(quarto) || !file.exists(quarto)) {
    stop(
      "Quarto was not found. Install it from https://quarto.org/ or pass its ",
      "executable path with quarto = ...",
      call. = FALSE
    )
  }

  output_dir <- file.path(path, "output", "manuscript")
  dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
  old_wd <- getwd()
  setwd(path)
  on.exit(setwd(old_wd), add = TRUE)

  run_quarto <- function(args) {
    result <- tryCatch(
      system2(
        quarto,
        args = args,
        stdout = if (isTRUE(quiet)) TRUE else "",
        stderr = if (isTRUE(quiet)) TRUE else ""
      ),
      error = function(error) {
        structure(1L, error = conditionMessage(error))
      }
    )
    error_message <- attr(result, "error", exact = TRUE)
    status <- attr(result, "status", exact = TRUE)
    if (is.null(status)) status <- if (is.numeric(result)) result[[1L]] else 0L
    if (!is.null(error_message) || !identical(as.integer(status), 0L)) {
      message <- if (is.null(error_message)) {
        paste("Quarto exited with status", status)
      } else {
        error_message
      }
      stop(message, call. = FALSE)
    }
    invisible(result)
  }

  if (render_all) {
    run_quarto(c("render", "paper.qmd"))
  } else {
    for (format in formats) {
      run_quarto(c("render", "paper.qmd", "--to", format))
    }
  }

  tex_file <- NULL
  if ("pdf" %in% formats) {
    candidates <- list.files(
      output_dir,
      pattern = "\\.tex$",
      recursive = TRUE,
      full.names = TRUE
    )
    candidates <- candidates[file.exists(candidates)]
    if (length(candidates) == 0L) {
      stop(
        "PDF rendering completed but Quarto did not retain a TeX file. ",
        "Confirm that keep-tex: true is set in _quarto.yml.",
        call. = FALSE
      )
    }
    source_tex <- candidates[[which.max(file.info(candidates)$mtime)]]
    tex_file <- file.path(path, "paper.tex")
    if (!file.copy(source_tex, tex_file, overwrite = TRUE)) {
      stop("Could not copy the rendered TeX file to: ", tex_file, call. = FALSE)
    }
  }

  structure(
    list(
      path = path,
      formats = formats,
      output_dir = output_dir,
      tex_file = tex_file
    ),
    class = "paperrepo_render"
  )
}
