# ---- 07_dashboard_shiny.R ----
# Painel interativo com previsão de aluguer de bicicletas para Seoul

library(shiny)
library(leaflet)
library(ggplot2)
library(dplyr)
library(readr)
library(tidymodels)

# ---- Carregar previsão do tempo para Seoul ----
previsao <- read_csv("../data_raw/forecast_seoul.csv",
                     locale = locale(encoding = "UTF-8"))

previsao <- previsao %>%
  rename(
    temperature_c = temperatura,
    humidity_percent = humidade,
    wind_speed_m_s = vento
  ) %>%
  mutate(datetime = as.POSIXct(datetime))

# ---- Carregar modelo treinado a partir da base de dados ----
con <- DBI::dbConnect(RSQLite::SQLite(), "../data_raw/bike_project.db")
seoul <- dbReadTable(con, "seoul_bike")

modelo_data <- seoul %>%
  select(rented_bike_count, temperature_c, humidity_percent, wind_speed_m_s) %>%
  na.omit()

# Dividir dados
set.seed(123)
split <- initial_split(modelo_data, prop = 0.8)
train_data <- training(split)

# Criar e treinar modelo com normalização
modelo_final <- workflow() %>%
  add_recipe(
    recipe(rented_bike_count ~ ., data = train_data) %>%
      step_normalize(all_numeric_predictors())
  ) %>%
  add_model(linear_reg() %>% set_engine("lm")) %>%
  fit(data = train_data)

# ---- Previsão para os dados meteorológicos ----
forecast_df <- previsao %>%
  select(datetime, temperature_c, humidity_percent, wind_speed_m_s)

forecast_df <- forecast_df %>%
  bind_cols(predict(modelo_final, new_data = forecast_df)) %>%
  rename(predito = .pred)

# ---- UI ----
ui <- fluidPage(
  titlePanel("Previsão de Aluguer de Bicicletas - Seoul"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("hora",
                  "Selecionar intervalo:",
                  min = min(forecast_df$datetime),
                  max = max(forecast_df$datetime),
                  value = min(forecast_df$datetime),
                  step = 3 * 3600,
                  timeFormat = "%d/%m %Hh")
    ),
    mainPanel(
      leafletOutput("mapa"),
      plotOutput("grafico")
    )
  )
)

# ---- Server ----
server <- function(input, output) {
  
  output$mapa <- renderLeaflet({
    leaflet() %>%
      addTiles() %>%
      setView(lng = 126.9780, lat = 37.5665, zoom = 11) %>%
      addMarkers(lng = 126.9780, lat = 37.5665,
                 popup = "Seoul")
  })
  
  output$grafico <- renderPlot({
    dados <- forecast_df %>%
      filter(datetime <= input$hora)
    
    if (nrow(dados) >= 2) {
      ggplot(dados, aes(x = datetime, y = predito)) +
        geom_line(color = "steelblue", size = 1.2) +
        geom_point(color = "darkblue") +
        labs(title = "Previsão da procura de bicicletas",
             x = "Data/Hora", y = "Bicicletas Previstas") +
        theme_minimal()
    } else {
      ggplot(dados, aes(x = datetime, y = predito)) +
        geom_point(color = "darkred", size = 3) +
        labs(title = "Apenas um ponto disponível",
             x = "Data/Hora", y = "Bicicletas Previstas") +
        theme_minimal()
    }
  })
}

# ---- Iniciar App ----
shinyApp(ui = ui, server = server)
