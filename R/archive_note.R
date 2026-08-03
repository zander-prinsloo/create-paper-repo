#' Archive a dated research note
#'
#' Writes a Markdown note to notes/archive/ and adds a link to
#' notes/INDEX.md. This keeps rough ideas and completed decisions searchable
#' without mixing them into the active to-do list.
#'
#' @param title Short title for the note and its filename.
#' @param body Markdown content for the note.
#' @param path Path to a paper project.
#' @param date Date to use in the filename and note header. Defaults to today.
#'
#' @return The created note path, invisibly.
#' @examples
#' \dontrun{
#' archive_note(
#'   title = "Resolve missingness decision",
#'   body = "Compare complete-case and weighted estimates.",
#'   path = "my-paper"
#' )
#' }
#' @export
archive_note <- function(
    title,
    body = "",
    path = ".",
    date = Sys.Date()) {
  path <- .normalize_project_path(path, must_exist = TRUE)
  if (length(title) != 1L || !is.character(title) || is.na(title) ||
      !nzchar(trimws(title))) {
    stop("title must be a single, non-empty character string.", call. = FALSE)
  }
  if (length(body) != 1L || !is.character(body) || is.na(body)) {
    stop("body must be a single, non-missing character string.", call. = FALSE)
  }
  date <- as.Date(date)
  if (length(date) != 1L || is.na(date)) {
    stop("date must be a single valid Date.", call. = FALSE)
  }

  archive_dir <- file.path(path, "notes", "archive")
  index_file <- file.path(path, "notes", "INDEX.md")
  dir.create(archive_dir, recursive = TRUE, showWarnings = FALSE)

  date_string <- format(date, "%Y-%m-%d")
  filename <- paste0(date_string, "--", .slugify(title), ".md")
  note_file <- file.path(archive_dir, filename)
  if (file.exists(note_file)) {
    stop("An archived note with this date and title already exists.", call. = FALSE)
  }

  note <- c(
    paste0("# ", trimws(title)),
    "",
    paste0("Date: ", date_string),
    "",
    body
  )
  .write_text(note_file, note)

  if (file.exists(index_file)) {
    index <- readLines(index_file, warn = FALSE, encoding = "UTF-8")
  } else {
    index <- c("# Notes index", "", "## Archived notes", "")
  }
  if (!any(grepl(filename, index, fixed = TRUE))) {
    if (length(index) > 0L && nzchar(index[[length(index)]])) index <- c(index, "")
    index <- c(
      index,
      paste0("- [", date_string, "](archive/", filename, ") - ", trimws(title))
    )
    .write_text(index_file, index)
  }

  invisible(note_file)
}
