library(dplyr)
library(stringr)
library(tidytext)
library(tidyr)
library(ggplot2)
library(readr)


# discursos de campanha de hillary clinton

#Discurso numero 8 do site
#setwd("D:\\OneDrive\\Universidade\\Doutorado\\1ºSemestre\\Disciplinas\\MetodosComputacionaisEmEstatistica\\Trabalhos\\SeminárioTextMining\\Aplicacoes\\Hillary_vs_Trump")

hc8 <- read_delim("https://github.com/mariofdesousa/seminarTextMining/blob/master/hc8.csv","\t", escape_double = FALSE,col_names =FALSE)
hc11 <- read_delim("https://github.com/mariofdesousa/seminarTextMining/blob/master/hc11.csv","\t", escape_double = FALSE,col_names =FALSE)
 

 
#HC8 - 26 jan 2016
 class(hc8)
 names(hc8)
 dim(hc8)
 head(data_frame(hc11line=1:150,text = as.character(hc8$X1)))
 head(hc8)

  tidy_hc8 <- data_frame(line=1:150,text = as.character(hc8$X1)) %>%  
   unnest_tokens(word, text)
 tidy_hc8
 
 data(stop_words)
 
 tidy_hc8_nostop <- tidy_hc8 %>%
   anti_join(stop_words)
 
 tidy_hc8_nostop %>%
   count(word, sort=TRUE) %>%
   filter(n>10) %>%
   mutate(word = reorder(word, n)) %>%
   ggplot(aes(x=word,y=n)) +
   geom_col()+
   coord_flip() 
 
 # HC11 01 fev 2016
 head(hc11)
 class(hc11)
 names(hc11)
 dim(hc11)

 head(data_frame(hc11line=1:150,text = as.character(hc11$X1)))
 
 tidy_hc11 <- data_frame(line=1:150,text = as.character(hc11$X1)) %>%  
   unnest_tokens(word, text)
 
 tidy_hc11
 data(stop_words)
 
 tidy_hc11_nostop <- tidy_hc11 %>%
   anti_join(stop_words)
 
 tidy_hc11_nostop %>%
   count(word, sort=TRUE) %>%
   filter(n>10) %>%
   mutate(word = reorder(word, n)) %>%
   ggplot(aes(x=word,y=n)) +
   geom_col()+
   coord_flip()
 
## HC8 e HC11
 
 freq_hc8_hc11 <- bind_rows(mutate(tidy_hc8_nostop,speech="HC8"),
                        mutate(tidy_hc11_nostop,speech="HC11"))%>%
   mutate(word = str_extract(word, "[a-z']+")) %>%
   count(speech, word) %>%
   group_by(speech) %>%
   mutate(proportion = n / sum(n)) %>% 
   select(-n) %>% 
   spread(speech, proportion)
 
 head(freq_hc8_hc11,10)
  

library(scales) 
 
 ggplot(freq_hc8_hc11,aes(x=HC8,y=HC11))+
   geom_abline(color = "red", lty = 2,lwd=1.5)+
   geom_text(aes(label = word), check_overlap = TRUE, vjust = 1.5)+
   scale_x_log10(labels = percent_format()) +
   scale_y_log10(labels = percent_format()) +
   scale_color_gradient(limits = c(0, 0.001), low = "darkslategray4",
                        high = "gray75")

 ## Podemos notar que ambos os discursos são muito parecidos. As proporções de 
 ## palavras em ambos os textos são semelhantes 
 