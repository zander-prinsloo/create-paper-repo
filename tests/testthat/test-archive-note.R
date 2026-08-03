test_that("archive_note writes a dated note and updates the index", {
  project <- file.path(tempdir(), paste0("paperrepo-notes-", as.integer(Sys.time())))
  on.exit(unlink(project, recursive = TRUE, force = TRUE), add = TRUE)
  create_paper_project(project, init_renv = FALSE)

  note <- archive_note(
    "Resolve missingness decision",
    body = "Compare complete-case and weighted estimates.",
    path = project,
    date = as.Date("2026-01-02")
  )
  index <- readLines(file.path(project, "notes", "INDEX.md"))

  expect_true(file.exists(note))
  expect_true(grepl("2026-01-02--resolve-missingness-decision.md", note, fixed = TRUE))
  expect_true(any(grepl("Resolve missingness decision", index, fixed = TRUE)))
  expect_true(any(grepl("weighted estimates", readLines(note), fixed = TRUE)))
  expect_error(
    archive_note(
      "Resolve missingness decision",
      path = project,
      date = as.Date("2026-01-02")
    ),
    "already exists"
  )
})
