# ---- 13_metricas_comparativas.R ----

library(tidymodels)
library(dplyr)
library(ggplot2)
library(tibble)

# 1. Calcular métricas para cada modelo
metricas_v2 <- metrics(predict_v2, truth = rented_bike_count, estimate = .pred) %>%
  mutate(modelo = "v2")
metricas_v3 <- metrics(predict_v3, truth = rented_bike_count, estimate = .pred) %>%
  mutate(modelo = "v3")
metricas_v4 <- metrics(predict_v4, truth = rented_bike_count, estimate = .pred) %>%
  mutate(modelo = "v4")

# 2. Juntar num só dataframe
metricas_all <- bind_rows(metricas_v2, metricas_v3, metricas_v4)

# 3. Gráfico de barras com métricas
ggplot(metricas_all, aes(x = .metric, y = .estimate, fill = modelo)) +
  geom_col(position = "dodge") +
  labs(title = "📊 Comparação de Métricas dos Modelos",
       x = "Métrica", y = "Valor", fill = "Modelo") +
  theme_minimal()

# 4. Guardar gráfico
ggsave("comparativo_metricas_modelos.png", width = 8, height = 5)

# 5. Guardar CSV de resumo (opcional para relatório)
write.csv(metricas_all, "data_raw/resumo_metricas_modelos.csv", row.names = FALSE)
