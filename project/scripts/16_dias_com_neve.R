# ---- 16_dias_com_neve.R ----

library(readr)
library(dplyr)
library(lubridate)
library(janitor)

# 1. Carregar e preparar dados
seoul <- read_csv("data_raw/raw_seoul_bike_sharing.csv", locale = locale(encoding = "ISO-8859-1")) %>%
  clean_names() %>%
  mutate(date = dmy(date))

# 2. Agrupar por data e somar neve
dias_com_neve <- seoul %>%
  group_by(date) %>%
  summarise(total_neve = sum(snowfall_cm, na.rm = TRUE)) %>%
  filter(total_neve > 0)

# 3. Mostrar resultado no console
cat("❄️ Total de dias com queda de neve:", nrow(dias_com_neve), "\n")

# 4. Guardar CSV com os dias com neve
write_csv(dias_com_neve, "data_raw/dias_com_queda_de_neve.csv")
