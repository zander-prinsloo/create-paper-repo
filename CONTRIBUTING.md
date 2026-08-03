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

## Pull requests

Keep commits focused and explain user-facing behavior in the pull request.
Please include tests for new behavior and update the README or function
documentation when the public API changes.
