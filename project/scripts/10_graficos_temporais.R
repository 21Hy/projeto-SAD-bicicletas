# ---- 10_graficos_temporais.R ----

library(ggplot2)
library(dplyr)
library(readr)
library(lubridate)
library(janitor)

# 1. Carregar e preparar os dados
seoul <- read_csv("data_raw/raw_seoul_bike_sharing.csv", locale = locale(encoding = "ISO-8859-1")) %>%
  clean_names() %>%
  mutate(
    date = dmy(date),
    hour = factor(hour, levels = 0:23, ordered = TRUE)
  )

# 2. Tarefa 10 - Gráfico de dispersão RENTED_BIKE_COUNT vs DATE
g1 <- ggplot(seoul, aes(x = date, y = rented_bike_count)) +
  geom_point(alpha = 0.4, color = "steelblue") +
  labs(title = "Tarefa 10: Dispersão de Alugueres vs Data",
       x = "Data", y = "Bicicletas Alugadas") +
  theme_minimal()

ggsave("graficos/tarefa10_disp_data.png", g1, width = 9, height = 5)

# 3. Tarefa 11 - Mesmo gráfico, agora com cor por HORA
g2 <- ggplot(seoul, aes(x = date, y = rented_bike_count, color = hour)) +
  geom_point(alpha = 0.5) +
  labs(title = "Tarefa 11: Dispersão com cor por Hora",
       x = "Data", y = "Bicicletas Alugadas") +
  theme_minimal()

ggsave("graficos/tarefa11_disp_data_hour_color.png", g2, width = 9, height = 5)

# 4. Tarefa 12 - Histograma com curva de densidade kernel
g3 <- ggplot(seoul, aes(x = rented_bike_count)) +
  geom_histogram(aes(y = ..density..), fill = "skyblue", bins = 30, alpha = 0.7) +
  geom_density(color = "darkblue", size = 1) +
  labs(title = "Tarefa 12: Histograma com Curva de Densidade",
       x = "Bicicletas Alugadas", y = "Densidade") +
  theme_minimal()

ggsave("graficos/tarefa12_hist_densidade.png", g3, width = 9, height = 5)
