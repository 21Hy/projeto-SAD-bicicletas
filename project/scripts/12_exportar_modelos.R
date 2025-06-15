# ---- 12_exportar_modelos.R ----

library(ggplot2)
library(dplyr)
library(readr)

# 1. Adicionar coluna identificadora a cada modelo
v2 <- predict_v2 %>% mutate(modelo = "v2")
v3 <- predict_v3 %>% mutate(modelo = "v3")
v4 <- predict_v4 %>% mutate(modelo = "v4")

# 2. Combinar num único dataframe
comparacao <- bind_rows(v2, v3, v4)

# 3. Gráfico: valores reais vs previstos
p <- ggplot(comparacao, aes(x = rented_bike_count, y = .pred, color = modelo)) +
  geom_point(alpha = 0.3) +
  geom_abline(slope = 1, intercept = 0, linetype = "dashed") +
  facet_wrap(~ modelo) +
  theme_minimal() +
  labs(title = "📈 Previsão vs Real (Modelos v2, v3, v4)",
       x = "Valor Real", y = "Previsão", color = "Modelo")

# 4. Guardar imagem na pasta principal
ggsave("real_vs_previsto_comparativo.png", p, width = 10, height = 5)


# 5. Exportar previsões para CSV na pasta data_raw
write_csv(predict_v2, "data_raw/previsao_v2.csv")
write_csv(predict_v3, "data_raw/previsao_v3.csv")
write_csv(predict_v4, "data_raw/previsao_v4.csv")

