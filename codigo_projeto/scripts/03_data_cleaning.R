# Instalar pacotes (só na primeira vez)
install.packages("dplyr")
install.packages("readr")
install.packages("stringr")
install.packages("lubridate")

# Carregar pacotes
library(dplyr)
library(readr)
library(stringr)
library(lubridate)


# Carregar ficheiro
bike_raw <- read_csv("data_raw/raw_bike_sharing_systems.csv")

# Verificar colunas
colnames(bike_raw)

# Padronizar nomes de colunas
colnames(bike_raw) <- str_to_lower(gsub(" ", "_", colnames(bike_raw)))

# Ver dados nulos
colSums(is.na(bike_raw))

# Exemplo: remover links de referência com expressões regulares
bike_raw <- bike_raw %>% mutate_all(~str_replace_all(., "\\[.*?\\]", ""))

# Guardar versão limpa (opcional nesta fase)
write_csv(bike_raw, "data_raw/clean_bike_sharing_systems.csv")

# Lista de cidades usadas
cidades <- c("seoul", "paris", "new_york", "suzhou", "london")

# Caminho base
caminho <- "data_raw/"

# Função para limpar cada ficheiro
limpar_forecast <- function(cidade) {
  ficheiro <- paste0(caminho, "forecast_", cidade, ".csv")
  print(paste("📥 A carregar:", ficheiro))
  
  # Ler
  dados <- read_csv(ficheiro, show_col_types = FALSE)
  
  # Verificar nomes de colunas
  dados <- dados %>%
    rename_with(tolower) %>%
    rename_with(~str_replace_all(., " ", "_"))
  
  # Normalizar coluna de data
  dados <- dados %>%
    mutate(datetime = ymd_hms(datetime),
           cidade = str_to_title(str_replace_all(cidade, "_", " ")))
  
  # Remover espaços e por tudo lowercase na descrição
  dados$descricao <- str_to_lower(trimws(dados$descricao))
  
  # Verificar NA
  print(paste("→ NAs em", cidade, ":", sum(is.na(dados))))
  
  return(dados)
}

# Aplicar a função a todas as cidades
lista_forecasts <- lapply(cidades, limpar_forecast)

# Juntar tudo num único dataframe (opcional mas útil!)
previsoes_todas <- bind_rows(lista_forecasts)

# Ver primeiros dados
head(previsoes_todas)

# Guardar ficheiro final limpo (opcional)
write_csv(previsoes_todas, paste0(caminho, "forecast_todas_cidades_limpas.csv"))
