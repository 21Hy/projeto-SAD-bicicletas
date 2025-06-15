# ---- 14_boxplot_por_estacao.R ----

library(ggplot2)
library(dplyr)
library(readr)
library(lubridate)
library(janitor)

# 1. Carregar e preparar os dados
seoul <- read_csv("data_raw/raw_seoul_bike_sharing.csv", locale = locale(encoding = "ISO-8859-1")) %>%
  clean_names() %>%
  mutate(
    hour = factor(hour, levels = 0:23, ordered = TRUE),
    seasons = factor(seasons, levels = c("Winter", "Spring", "Summer", "Autumn"))
  )

# 2. Criar os boxplots facetados por estação
g_box <- ggplot(seoul, aes(x = hour, y = rented_bike_count)) +
  geom_boxplot(fill = "skyblue", outlier.alpha = 0.2) +
  facet_wrap(~ seasons) +
  labs(
    title = "Tarefa 14: Boxplots de Bicicletas Alugadas por Hora, agrupado por Estação",
    x = "Hora do Dia", y = "Bicicletas Alugadas"
  ) +
  theme_minimal()

# 3. Guardar o gráfico
ggsave("graficos/tarefa14_boxplots_hour_season.png", g_box, width = 10, height = 6)
