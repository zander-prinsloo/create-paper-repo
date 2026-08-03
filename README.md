# paperrepo

paperrepo creates a clear, reproducible workspace for an empirical research
paper. It is designed for authors who want one repository to carry a project
from raw data and exploratory work through analysis, manuscript writing,
journal submission, and reproducibility-package handoff.

## Install

Install the development version from GitHub:

~~~r
install.packages("pak")
pak::pak("zander-prinsloo/create-paper-repo")
~~~

## Create a paper project

Create a new directory for each paper. By default, paperrepo creates the
full structure and initializes renv when renv is installed.

~~~r
paperrepo::create_paper_project("my-paper", project_name = "My empirical paper")
~~~

If renv is not installed yet, install it and run the command again, or run
renv::init("my-paper", bare = TRUE) after creating the scaffold. The
scaffold still includes a valid starting lockfile and instructions when the
optional renv package is unavailable.

The generated project looks like this:

~~~text
my-paper/
âââ README.md
âââ _quarto.yml
âââ paper.qmd
âââ paper.tex                 # refreshed from the PDF render
âââ data/
â   âââ raw/
â   âââ processed/
âââ R/                        # ordered analysis scripts
âââ code/                     # non-R utilities, commands, or notebooks
âââ sandbox/                  # disposable exploration
âââ notes/
â   âââ active.md
â   âââ INDEX.md
â   âââ archive/
âââ output/
â   âââ manuscript/
â   âââ results/
â   âââ tables/
â   âââ figures/
âââ scripts/
âââ renv.lock
~~~

## Render the manuscript

Install Quarto (https://quarto.org/docs/get-started/) and a PDF engine such
as TinyTeX before rendering. From the paper project, either render all three
formats together:

~~~r
paperrepo::render_paper("my-paper", formats = "all")
~~~

or render only selected formats:

~~~r
paperrepo::render_paper("my-paper", formats = c("pdf", "docx"))
paperrepo::render_paper("my-paper", formats = "html")
~~~

The outputs are written to output/manuscript/. PDF rendering keeps the
Quarto-generated TeX and copies it to paper.tex at the project root so it is
easy to submit to a journal.

The same workflow is available without loading R:

~~~sh
Rscript scripts/render-paper.R
~~~

## Research notes

Keep current tasks and rough thinking in notes/active.md. When a note is
finished or superseded, archive it with a date and add it to the index:

~~~r
paperrepo::archive_note(
  "Resolve missingness decision",
  body = "Compare complete-case and inverse-probability-weighted estimates.",
  path = "my-paper"
)
~~~

## Reproducibility checklist

Before sharing the repository, run the checks in the generated README:

1. Put immutable or legally shareable inputs in data/raw/ and document their
   provenance.
2. Keep transformation and estimation scripts in R/ in execution order.
3. Keep generated results, tables, and figures in the corresponding output/
   subfolders; do not hand-edit them.
4. Run renv::snapshot() after changing package dependencies.
5. Run paperrepo::check_paper_project() and render the paper from a clean R
   session before submission.

## Status

This package is under active development. The public API is intentionally small
and will remain conservative while the project matures.

## License

MIT Â© Zander Prinsloo.
