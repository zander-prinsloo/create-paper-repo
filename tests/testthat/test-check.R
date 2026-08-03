test_that("check_paper_project passes for a generated project", {
  project <- file.path(tempdir(), paste0("paperrepo-check-", as.integer(Sys.time())))
  on.exit(unlink(project, recursive = TRUE, force = TRUE), add = TRUE)
  create_paper_project(project, init_renv = FALSE)

  result <- check_paper_project(project)

  expect_s3_class(result, "paper_project_check")
  expect_true(result$ok)
  expect_true(all(result$files$present))
  expect_true(file.exists(file.path(project, "scripts", "run-analysis.R")))
})

test_that("check_paper_project identifies missing paths", {
  project <- tempfile("paperrepo-incomplete-")
  dir.create(project)
  on.exit(unlink(project, recursive = TRUE, force = TRUE), add = TRUE)
  writeLines("", file.path(project, "paper.qmd"))

  result <- check_paper_project(project)

  expect_false(result$ok)
  expect_true(any(!result$files$present))
  expect_output(print(result), "INCOMPLETE")
})
