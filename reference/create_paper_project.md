# Create a reproducible empirical paper project

Creates a Quarto-first project with conventional locations for data,
analysis code, exploratory work, research notes, manuscript outputs, and
reproducibility metadata. Existing files are never removed.

## Usage

``` r
create_paper_project(
  path = ".",
  project_name = NULL,
  overwrite = FALSE,
  init_renv = TRUE,
  quiet = FALSE
)
```

## Arguments

- path:

  Directory to create. It may be a new directory.

- project_name:

  Human-readable title used in the generated files. If omitted, the
  directory name is used.

- overwrite:

  Whether existing template files may be replaced. This does not remove
  files that are not part of the scaffold.

- init_renv:

  Whether to initialize renv after writing the scaffold. Initialization
  is deferred with a warning when renv is not installed.

- quiet:

  Whether renv should suppress its progress output.

## Value

An object of class "paper_project" containing the project path, created
files, and renv initialization status.

## Examples

``` r
if (FALSE) { # \dontrun{
project <- file.path(tempdir(), "my-paper")
create_paper_project(
  project,
  project_name = "My empirical paper",
  init_renv = FALSE
)
} # }
```
