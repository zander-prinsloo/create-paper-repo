test_that("create_paper_project creates the complete scaffold", {
  project <- file.path(tempdir(), paste0("paperrepo-", as.integer(Sys.time())))
  on.exit(unlink(project, recursive = TRUE, force = TRUE), add = TRUE)

  result <- create_paper_project(
    project,
    project_name = "A Test Paper",
    init_renv = FALSE
  )

  expect_s3_class(result, "paper_project")
  expect_equal(result$project_name, "A Test Paper")
  expect_equal(result$renv, "template-only")
  expect_true(file.exists(file.path(project, "paper.qmd")))
  expect_true(file.exists(file.path(project, "paper.tex")))
  expect_true(file.exists(file.path(project, ".gitignore")))
  expect_true(grepl("A Test Paper", readLines(file.path(project, "paper.qmd"))[2]))
  expect_true(grepl('"Version"', readLines(file.path(project, "renv.lock"))[3], fixed = TRUE))
})

test_that("creation protects a non-empty target unless overwrite is requested", {
  project <- file.path(tempdir(), paste0("paperrepo-nonempty-", as.integer(Sys.time())))
  dir.create(project, recursive = TRUE)
  on.exit(unlink(project, recursive = TRUE, force = TRUE), add = TRUE)
  writeLines("keep me", file.path(project, "custom.txt"))

  expect_error(
    create_paper_project(project, init_renv = FALSE),
    "not empty"
  )

  result <- create_paper_project(project, overwrite = TRUE, init_renv = FALSE)
  expect_s3_class(result, "paper_project")
  expect_equal(readLines(file.path(project, "custom.txt")), "keep me")
})
