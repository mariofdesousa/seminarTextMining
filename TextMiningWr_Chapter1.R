######## CHAPTER 1


text <- c("Because I could not stop for Death -",
          "He kindly stopped for me -",
          "The Carriage held but just Ourselves -",
          "and Immortality")

text

library(dplyr)
text_df <- data_frame(line = 1:4, text = text)

text_df

# Notice that this data frame containing text isn’t yet compatible with tidy 
# text analysis, though. We can’t filter out words or count which occur most
# frequently, since each row is made up of multiple combined words. We need
# to convert this so that it has one-token-per-document-per-row.
#  

library(tidytext)

text_df %>% unnest_tokens(word,text)

library(janeaustenr)
library(dplyr)
library(stringr)

original_books <- austen_books() %>%
                  group_by(book) %>%
                  mutate(linenumber = row_number(),
                  chapter = cumsum(str_detect(text, regex("^chapter [\\divxlc]",
                                                 ignore_case = TRUE)))) %>%
  
  ungroup()

original_books

tidy_books <- original_books %>% 
              unnest_tokens(word,text)
tidy_books


### Geralmente queremos remover palavras do tipo "of,the"
data(stop_words)

tidy_books <- tidy_books %>%
  anti_join(stop_words)


#### Contagem de palavras
tidy_books %>% count(word, sort=TRUE)

## Visualização

library(ggplot2)

tidy_books %>%
  count(word, sort = TRUE) %>%
  filter(n > 600) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(word, n)) +
  geom_col() +
  xlab(NULL) +
  coord_flip()


### Usando outros textos do projeto gutenbergr

library(gutenbergr)

hgwells <- gutenberg_download(c(35, 36, 5230, 159))

tidy_hgwells <- hgwells %>%
  unnest_tokens(word, text) %>%
  anti_join(stop_words)

tidy_hgwells %>%
  count(word, sort = TRUE)


### Mais textos

bronte <- gutenberg_download(c(1260, 768, 969, 9182, 767))
tidy_bronte <- bronte %>%
  unnest_tokens(word, text) %>%
  anti_join(stop_words)

#What are the most common words in these novels of the Brontë sisters?

tidy_bronte %>%
  count(word, sort = TRUE)


### Comparando semelhancas entre os textos
### Now, let’s calculate the frequency for each word for the works of
### Jane Austen, the Brontë sisters, and H.G. Wells by binding the data
### frames together. We can use spread and gather from tidyr to reshape 
### our dataframe so that it is just what we need for plotting and comparing
### the three sets of novels.
library(tidyr)

frequency <- bind_rows(mutate(tidy_bronte, author = "Brontë Sisters"),
                       mutate(tidy_hgwells, author = "H.G. Wells"), 
                       mutate(tidy_books, author = "Jane Austen")) %>% 
  mutate(word = str_extract(word, "[a-z']+")) %>%
  count(author, word) %>%
  group_by(author) %>%
  mutate(proportion = n / sum(n)) %>% 
  select(-n) %>% 
  spread(author, proportion) %>% 
  gather(author, proportion, `Brontë Sisters`:`H.G. Wells`)

#We use str_extract() here because the UTF-8 encoded texts from Project
#Gutenberg have some examples of words with underscores around them
#to indicate emphasis (like italics). The tokenizer treated these as
#words, but we don’t want to count “_any_” separately from “any” as
#we saw in our initial data exploration before choosing to use str_extract().

# Visualizando os dados

library(scales)

# expect a warning about rows with missing values being removed
ggplot(frequency, aes(x = proportion, y = `Jane Austen`, 
                      color = abs(`Jane Austen` - proportion))) +
  geom_abline(color = "gray40", lty = 2) +
  geom_jitter(alpha = 0.1, size = 2.5, width = 0.3, height = 0.3) +
  geom_text(aes(label = word), check_overlap = TRUE, vjust = 1.5) +
  scale_x_log10(labels = percent_format()) +
  scale_y_log10(labels = percent_format()) +
  scale_color_gradient(limits = c(0, 0.001), low = "darkslategray4", 
                       high = "gray75") +
  facet_wrap(~author, ncol = 2) +
  theme(legend.position="none") +
  labs(y = "Jane Austen", x = NULL)

## Teste usual de correlacao

cor.test(data = frequency[frequency$author == "Brontë Sisters",],
         ~ proportion + `Jane Austen`)

cor.test(data = frequency[frequency$author == "H.G. Wells",], 
         ~ proportion + `Jane Austen`)