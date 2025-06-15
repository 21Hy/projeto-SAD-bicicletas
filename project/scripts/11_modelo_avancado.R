# ---- 11_modelo_avancado.R ----
# Modelos de regressão com variáveis temporais, polinómios e regularização

library(tidymodels)
library(dplyr)
library(ggplot2)

# 1. Preparar dados com variáveis temporais
modelo_data <- seoul %>%
  select(rented_bike_count, temperature_c, humidity_percent, wind_speed_m_s,
         hour, seasons, holiday) %>%
  na.omit() %>%
  mutate(
    hour = factor(hour, levels = 0:23, ordered = TRUE),
    seasons = factor(seasons),
    holiday = factor(holiday)
  )

# 2. Dividir em treino e teste
set.seed(123)
split <- initial_split(modelo_data, prop = 0.8)
train_data <- training(split)
test_data  <- testing(split)

# 3. Modelo v2: com variáveis temporais
receita_v2 <- recipe(rented_bike_count ~ ., data = train_data) %>%
  step_dummy(all_nominal_predictors()) %>%
  step_normalize(all_numeric_predictors())

modelo_v2 <- linear_reg() %>% 
  set_engine("lm")

workflow_v2 <- workflow() %>%
  add_recipe(receita_v2) %>%
  add_model(modelo_v2) %>%
  fit(data = train_data)

predict_v2 <- predict(workflow_v2, test_data) %>%
  bind_cols(test_data)

cat("📊 Modelo v2 - Com variáveis temporais:\n")
print(metrics(predict_v2, truth = rented_bike_count, estimate = .pred))

# 4. Modelo v3: termos polinomiais (temperatura^2)
receita_v3 <- receita_v2 %>%
  step_poly(temperature_c, degree = 2)

workflow_v3 <- workflow() %>%
  add_recipe(receita_v3) %>%
  add_model(modelo_v2) %>%
  fit(data = train_data)

predict_v3 <- predict(workflow_v3, test_data) %>%
  bind_cols(test_data)

cat("📊 Modelo v3 - Com temperatura^2:\n")
print(metrics(predict_v3, truth = rented_bike_count, estimate = .pred))

# 5. Modelo v4: regularização com glmnet
modelo_v4 <- linear_reg(penalty = 0.1, mixture = 0.5) %>%
  set_engine("glmnet")

workflow_v4 <- workflow() %>%
  add_recipe(receita_v2) %>%
  add_model(modelo_v4) %>%
  fit(data = train_data)

predict_v4 <- predict(workflow_v4, test_data) %>%
  bind_cols(test_data)

cat("📊 Modelo v4 - Regularização (glmnet):\n")
print(metrics(predict_v4, truth = rented_bike_count, estimate = .pred))

# Guardar modelo final com regularização
saveRDS(workflow_v4, "modelo_final.rds")


