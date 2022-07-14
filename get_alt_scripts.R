library(dplyr)
read_text_pdf <- function(url) {
  #Get episode details
  title <- gsub("^.*transcript\\-|[.]pdf", "", url)
  season <- stringr::str_extract(pattern = "^\\d{1}", title)
  episode <- gsub("^\\d{1}(\\d{2})", "\\1", stringr::str_extract(pattern = "^\\d{3}", title))
  episode_name <- gsub("[-]", " ", stringr::str_extract(pattern = "Chapter.*", title))

##Read text from PDF
  text <- pdftools::pdf_text(url) %>%
    strsplit("\n") %>%
    unlist()

  ##Only keep everything after the first page
  text <- text[grep(" Page |1", text, fixed = TRUE):length(text)]

  tibble(episode_name = episode_name,
                  season = season,
                  episode_number = episode,
                  utterance = text) %>%
    #Remove empty rows
    dplyr::filter(utterance != "") %>%
    ##Clean up strings
    dplyr::mutate(utterance = stringr::str_squish(utterance)) %>%
    #Remove nonsense rows
    dplyr::filter(!grepl("-->", utterance, fixed = TRUE)) %>%
    dplyr::filter(!grepl("^Page|^P a g e", utterance)) %>%
    dplyr::filter(!grepl("8FLiX|FOR EDUCATIONAL|This transcript is|Not to be sold", utterance)) %>%
    dplyr::filter(!grepl("^\\d+", utterance)) %>%
    #Remove leading symbols
    dplyr::mutate(utterance = gsub("^\\-", "", utterance))
}

table <- purrr::map_df(url_4, read_text_pdf) %>%
  ##Put in order
  dplyr::select(utterance, episode_name, season, episode_number) %>%
  dplyr::mutate(character = dplyr::case_when(grepl("^\\[.*\\]$", utterance) ~ "Scene Description",
                                             TRUE ~ ""))

##Save as CSV
write.csv(table, "text.csv", row.names = FALSE)
