# ---- 15_eda_complementar.R ----

library(readr)
library(dplyr)
library(ggplot2)
library(janitor)
library(lubridate)
library(skimr)

# 1. Carregar e preparar os dados
seoul <- read_csv("data_raw/raw_seoul_bike_sharing.csv", locale = locale(encoding = "ISO-8859-1")) %>%
  clean_names() %>%
  mutate(
    date = dmy(date),
    hour = factor(hour, levels = 0:23, ordered = TRUE),
    seasons = factor(seasons, levels = c("Winter", "Spring", "Summer", "Autumn"))
  )

# ========================
# Tarefa 4 – Resumo do conjunto de dados
# ========================
resumo <- skim(seoul)
write.csv(resumo, "data_analise/tarefa04_resumo.csv", row.names = FALSE)

# ========================
# Tarefa 5 – Quantos feriados existem
# ========================
n_feriados <- seoul %>% filter(holiday == "Holiday") %>% nrow()
cat("🎌 Número de registos em feriados:", n_feriados, "\n")

# ========================
# Tarefa 6 – Percentagem de registos em feriado
# ========================
percent_feriados <- mean(seoul$holiday == "Holiday") * 100
cat("📊 Percentagem de registos em feriado:", round(percent_feriados, 2), "%\n")

# ========================
# Tarefa 7 – Nº esperado de registos num ano
# ========================
cat("📅 Registos totais no dataset:", nrow(seoul), "\n")
cat("ℹ️ Esperado: 365 dias × 24 horas = 8760\n")

# ========================
# Tarefa 8 – Quantos registos funcionais
# ========================
n_funcionais <- seoul %>% filter(functioning_day == "Yes") %>% nrow()
cat("✅ Registos com functioning_day == Yes:", n_funcionais, "\n")

# ========================
# Tarefa 9 – Precipitação total + neve por estação
# ========================
precip_sazonal <- seoul %>%
  group_by(seasons) %>%
  summarise(
    total_precipitacao = sum(rainfall_mm, na.rm = TRUE),
    total_neve = sum(snowfall_cm, na.rm = TRUE)
  )

write_csv(precip_sazonal, "data_analise/tarefa09_precipitacao_sazonal.csv")

# ========================
# Tarefa 13 – Dispersão count vs temperatura, cor por hour, facet por season
# ========================
g_disp_temp <- ggplot(seoul, aes(x = temperature_c, y = rented_bike_count, color = hour)) +
  geom_point(alpha = 0.5) +
  facet_wrap(~ seasons) +
  labs(
    title = "Tarefa 13: Dispersão Alugueres vs Temperatura por Estação",
    x = "Temperatura (°C)", y = "Bicicletas Alugadas"
  ) +
  theme_minimal()

ggsave(filename = "graficos/tarefa13_disp_temp_por_season.png", plot = g_disp_temp, width = 10, height = 6)

# ========================
# Tarefa 15 – Soma de precipitação e neve por data
# ========================
clima_diario <- seoul %>%
  group_by(date) %>%
  summarise(
    total_precipitacao = sum(rainfall_mm, na.rm = TRUE),
    total_neve = sum(snowfall_cm, na.rm = TRUE)
  )

write_csv(clima_diario, "data_analise/tarefa15_precipitacao_diaria.csv")
