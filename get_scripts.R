library(xml2)
library(rvest)
library(dplyr)
library(stringr)

##For subtitles
##Read in links from URL
links <- "https://subslikescript.com/series/Stranger_Things-4574334" %>%
  read_html() %>%
  html_nodes("a") %>%
  html_attr("href")

##Search out only episode links
links <- links[grepl("episode", links, fixed = TRUE)]

read_links <- function(link){
  ##Check out the first link
  page <- read_html(paste0("https://subslikescript.com/", link )) %>%
    html_nodes("div.full-script") %>%
  #Clean up <br> line breaks for \n
    gsub(pattern = "<br>", replacement = "\n") %>%
    gsub(pattern = "\\\n[-]", replacement = "\n\n") %>%
    #Split into individual lines
    strsplit("\n\n") %>%
    unlist()

  table <- tibble(utterance = page) %>%
    ##Remove any google ads references
    dplyr::filter(!grepl("adsbygoogle", utterance)) %>%
    ##Add episode name
    dplyr::mutate(episode_name = link,
                  ##Get season and episode numbers, and episode name
                  season = gsub(".*season[-](\\d).*", "\\1", episode_name),
                  episode_number = gsub(".*episode[-](\\d).*", "\\1", episode_name),
                  episode_name = gsub(".*episode[-]\\d[-](.*)", "\\1", episode_name),
                  episode_name = gsub("_", " ", episode_name),
                  #Assign names of characters from strings
                  character = gsub("[:]", "",
                                   stringr::str_extract(utterance, "^(- |)[A-Z]{2,}?\\:")),
                  ##Clear up utterances
                  utterance = gsub("^(- |)[A-Z]{2,}?\\:", "", utterance),
                  utterance = gsub("[<].*[>]", "", utterance),
                  utterance = stringr::str_trim(gsub("\\\n", " ", utterance)),
                  #Indicate when utterances are just scene descriptions
                  character = dplyr::case_when(
                    !is.na(character) ~ character,
                    grepl("^\\[.*\\]$", utterance) ~ "Scene Description"
                  ),
                  character = stringr::str_to_title(tolower(character))

                  )

}

stranger_text <- purrr::map_df(links, read_links)

save(stranger_text, file = "stranger_text.rda")

##Write out a CSV so I can manually assign characters.
#This is a great idea and I will not regret manual data input for 30,000 lines

write.csv(strangeRthings::stranger_text,
                   "data/stranger_text1.csv",
                   row.names = FALSE,
                   fileEncoding = "ASCII")
