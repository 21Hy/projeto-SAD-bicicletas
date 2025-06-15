# ---- 09_regex_e_indicadores.R ----

library(dplyr)
library(readr)
library(stringr)
library(janitor)

# 1. Carregar e limpar dados dos sistemas de partilha de bicicletas
sistemas <- read_csv("data_raw/raw_bike_sharing_systems.csv", locale = locale(encoding = "UTF-8")) %>%
  janitor::clean_names()

# 2. 🔹 Remover links de referência com regex (de todas as colunas de texto)
sistemas_limpo <- sistemas %>%
  mutate(across(where(is.character), ~ str_remove_all(., "http[s]?://[^\\s\\]]+")))

# 3. 🔹 Extrair valores numéricos (exemplo aplicado se existir a coluna 'bike_count')
if ("bike_count" %in% names(sistemas_limpo)) {
  sistemas_limpo <- sistemas_limpo %>%
    mutate(bike_count_num = str_extract(bike_count, "\\d+")) %>%
    mutate(bike_count_num = as.numeric(bike_count_num))
}

# 4. Guardar versão limpa
write_csv(sistemas_limpo, "data_raw/sistemas_bike_limpo.csv")


# 5. 🔹 Carregar e limpar dados de Seoul
seoul <- read_csv("data_raw/raw_seoul_bike_sharing.csv", locale = locale(encoding = "ISO-8859-1")) %>%
  janitor::clean_names()

# 6. Criar variáveis indicadoras manualmente
seoul_indicadores <- seoul %>%
  mutate(
    holiday_flag = if_else(holiday == "Holiday", 1, 0),
    functioning_flag = if_else(functioning_day == "Yes", 1, 0)
  )

# 7. Guardar nova versão com indicadores
write_csv(seoul_indicadores, "data_raw/seoul_com_indicadores.csv")

