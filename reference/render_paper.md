# Render a paper with Quarto

Renders the manuscript into HTML, Word, PDF, or all three formats. The
generated files are placed in output/manuscript/. When PDF is rendered,
the TeX file retained by Quarto is copied to paper.tex at the project
root for journal submission.

## Usage

``` r
render_paper(path = ".", formats = "all", quarto = NULL, quiet = FALSE)
```

## Arguments

- path:

  Path to a paper project.

- formats:

  Character vector containing any of "pdf", "docx", and "html", or the
  single value "all".

- quarto:

  Optional path to the Quarto executable. By default, the executable is
  located with Sys.which("quarto").

- quiet:

  Whether to capture Quarto output.

## Value

An object of class "paperrepo_render" describing the rendered formats,
output directory, and TeX handoff.

## Examples

``` r
if (FALSE) { # \dontrun{
render_paper("my-paper", formats = "all")
render_paper("my-paper", formats = c("pdf", "docx"))
} # }
```
