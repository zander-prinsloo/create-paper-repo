# Check the structure of a paper project

Checks that the generated project contains the folders and files needed
for the paperrepo workflow.

## Usage

``` r
check_paper_project(path = ".")
```

## Arguments

- path:

  Path to a paper project.

## Value

An object of class "paper_project_check" with one row per required path
and a logical present field.

## Examples

``` r
if (FALSE) { # \dontrun{
check_paper_project("my-paper")
} # }
```
