# Instalar pacotes (só na 1ª vez)
install.packages("rvest")
install.packages("dplyr")
install.packages("readr")

# Carregar pacotes
library(rvest)
library(dplyr)
library(readr)

# Página da Wikipedia
url <- "https://en.wikipedia.org/wiki/List_of_bicycle-sharing_systems"

# Ler página e extrair tabelas
pagina <- read_html(url)
tabelas <- pagina %>% html_nodes("table")

# Tentar extrair a primeira tabela (a principal)
sistema_bikes <- tabelas[[1]] %>% html_table(fill = TRUE)

# Guardar como ficheiro CSV
write_csv(sistema_bikes, "raw_bike_sharing_systems.csv")

# Ver primeiros dados
head(sistema_bikes)

