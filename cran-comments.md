## R CMD check results

This is the development version of paperrepo following the initial public
repository release.

* Local source build: succeeds with --no-build-vignettes.
* Local check with --no-build-vignettes: 0 errors, 2 expected warnings, and
  1 note because this isolated environment does not have Pandoc or renv.
* The full vignette and website builds are configured to run in GitHub Actions,
  which installs Pandoc and all declared package dependencies.

## Reverse dependencies

There are no reverse dependencies for this initial release.
