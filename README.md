
[![R-CMD-check](https://github.com/BrydenFrancesca/strangeRthings/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/BrydenFrancesca/strangeRthings/actions/workflows/R-CMD-check.yaml)

The strangeRthings package aims to provide tidy format transcripts of
[Stranger Things](https://en.wikipedia.org/wiki/Stranger_Things)
episodes as an R package.

The data originates from the English language subtitles of the show.
This package presents the transcripts in a tidy tibble format, making
them easy to load and use in R.

## Installation

Install the strangeRthings package from [GitHub](https://github.com/)
with:

``` r
# install.packages("devtools")
devtools::install_github("BrydenFrancesca/strangeRthings")
```

## Example

The package comes with a single dataset (`stranger_text`), which is a
tibble containing all the utterances in the show.

``` r
library(strangeRthings)

dplyr::glimpse(stranger_text)
```

    ## Rows: 40,688
    ## Columns: 5
    ## $ utterance      <chr> "[CRICKETS CHIRPING]", "[ALARM BLARING]", "[PANTING]", …
    ## $ episode_name   <chr> "Chapter One The Vanishing of Will Byers", "Chapter One…
    ## $ season         <chr> "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", …
    ## $ episode_number <chr> "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", …
    ## $ character      <chr> "Scene Description", "Scene Description", "Scene Descri…

All the utterances are broken down by `season`, `episode`, and
`utterance` which allows for very detailed analysis. Please note that
the `character` will be denoted `"Scene Directions"` to show scene
directions, or otherwise non-spoken descriptions, and `Music` when
utterances correspond to music lyrics.
