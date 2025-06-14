# ---- 06_modelo_tidymodels.R ----
# Modelo de regressão + avaliação + gráfico exportável

library(DBI)
library(RSQLite)
library(dplyr)
library(ggplot2)
library(tidymodels)

# ---- Conectar à base de dados ----
con <- dbConnect(SQLite(), "data_raw/bike_project.db")
seoul <- dbReadTable(con, "seoul_bike")

# ---- Preparar dados ----
modelo_data <- seoul %>%
  select(rented_bike_count, temperature_c, humidity_percent, wind_speed_m_s) %>%
  na.omit()

# ---- Dividir em treino e teste ----
set.seed(123)
split <- initial_split(modelo_data, prop = 0.8)
train_data <- training(split)
test_data  <- testing(split)

# ---- Criar e treinar modelo ----
modelo_final <- workflow() %>%
  add_recipe(
    recipe(rented_bike_count ~ ., data = train_data) %>%
      step_normalize(all_numeric_predictors())
  ) %>%
  add_model(linear_reg() %>% set_engine("lm")) %>%
  fit(data = train_data)

# ---- Avaliar no conjunto de teste ----
predict_test <- predict(modelo_final, test_data) %>%
  bind_cols(test_data)

cat("📊 Métricas do modelo:\n")
print(metrics(predict_test, truth = rented_bike_count, estimate = .pred))

# ---- Gerar gráfico Real vs Previsão ----
grafico <- ggplot(predict_test, aes(x = rented_bike_count, y = .pred)) +
  geom_point(alpha = 0.4, color = "steelblue") +
  geom_abline(color = "red", linetype = "dashed") +
  labs(title = "Real vs Previsão (Conjunto de Teste)",
       x = "Aluguer Real",
       y = "Previsão do Modelo") +
  theme_minimal()

# ---- Mostrar gráfico no RStudio ----
print(grafico)

# ---- Exportar imagem ----
ggsave("real_vs_previsao.png", grafico, width = 7, height = 5)
cat("✅ Gráfico guardado em 'real_vs_previsao.png'\n")
