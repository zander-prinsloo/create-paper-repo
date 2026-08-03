# Archive a dated research note

Writes a Markdown note to notes/archive/ and adds a link to
notes/INDEX.md. This keeps rough ideas and completed decisions
searchable without mixing them into the active to-do list.

## Usage

``` r
archive_note(title, body = "", path = ".", date = Sys.Date())
```

## Arguments

- title:

  Short title for the note and its filename.

- body:

  Markdown content for the note.

- path:

  Path to a paper project.

- date:

  Date to use in the filename and note header. Defaults to today.

## Value

The created note path, invisibly.

## Examples

``` r
if (FALSE) { # \dontrun{
archive_note(
  title = "Resolve missingness decision",
  body = "Compare complete-case and weighted estimates.",
  path = "my-paper"
)
} # }
```
