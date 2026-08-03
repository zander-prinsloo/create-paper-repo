# Contributing to paperrepo

Thank you for helping make empirical research workflows easier to reproduce.

## Development setup

~~~r
install.packages(c("testthat", "roxygen2"))
~~~

Run the package checks from the repository root:

~~~sh
R CMD check . --no-manual --as-cran
~~~

The package does not require Quarto to run its unit tests. Changes to the
rendering helper should be tested manually in a paper project with Quarto
installed.

## Versioning and releases

The package uses the standard development-version suffix while work is
unreleased. For example, 0.1.0.9000 means development after the 0.1.0
baseline. In general:

- increment the patch component for backward-compatible fixes;
- increment the minor component for new backward-compatible public features;
- increment the major component for incompatible API changes.

Before a release, update DESCRIPTION, NEWS.md, CITATION.cff, and the package
citation together. Run R CMD check --as-cran, review cran-comments.md, and
create a matching version tag such as v0.1.0.

## Website

The pkgdown workflow builds the reference pages and vignette on every main
branch update and deploys the result to the gh-pages branch. Enable GitHub
Pages for this repository once, using gh-pages as the source branch and the
root directory.

## Pull requests

Keep commits focused and explain user-facing behavior in the pull request.
Please include tests for new behavior and update the README or function
documentation when the public API changes.
