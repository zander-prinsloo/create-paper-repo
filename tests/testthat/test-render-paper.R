test_that("render_paper validates formats and Quarto availability", {
  project <- file.path(tempdir(), paste0("paperrepo-render-", as.integer(Sys.time())))
  on.exit(unlink(project, recursive = TRUE, force = TRUE), add = TRUE)
  create_paper_project(project, init_renv = FALSE)

  expect_error(
    render_paper(project, formats = "latex", quarto = "/does/not/exist"),
    "formats must be"
  )
  expect_error(
    render_paper(project, formats = "html", quarto = "/does/not/exist"),
    "Quarto was not found"
  )
})
