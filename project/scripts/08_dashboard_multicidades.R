library(shiny)
library(leaflet)
library(ggplot2)
library(dplyr)
library(readr)
library(tidymodels)
library(lubridate)

# ---- Coordenadas das cidades ----
coords <- tibble::tibble(
  cidade = c("Seoul", "New York", "Paris", "Suzhou", "London"),
  lat = c(37.5665, 40.7128, 48.8566, 31.2989, 51.5074),
  lon = c(126.9780, -74.0060, 2.3522, 120.5853, -0.1278)
)

# ---- Carregar dados meteorológicos por cidade ----
nomes_ficheiros <- list(
  "Seoul" = "../data_raw/forecast_seoul.csv",
  "New York" = "../data_raw/forecast_new_york.csv",
  "Paris" = "../data_raw/forecast_paris.csv",
  "Suzhou" = "../data_raw/forecast_suzhou.csv",
  "London" = "../data_raw/forecast_london.csv"
)

dados_meteorologicos <- lapply(nomes_ficheiros, function(f) {
  read_csv(f, locale = locale(encoding = "UTF-8")) %>%
    rename(
      temperature_c = temperatura,
      humidity_percent = humidade,
      wind_speed_m_s = vento
    ) %>%
    mutate(datetime = as.POSIXct(datetime))
})

# ---- Carregar modelo treinado com glmnet ----
modelo_final <- readRDS("../modelo_final.rds")

# ---- UI ----
ui <- fluidPage(
  titlePanel("Previsão de Aluguer de Bicicletas - Cidades"),
  sidebarLayout(
    sidebarPanel(
      selectInput("cidade", "Selecionar cidade:", choices = names(nomes_ficheiros)),
      sliderInput("hora",
                  "Selecionar intervalo:",
                  min = min(dados_meteorologicos$Seoul$datetime),
                  max = max(dados_meteorologicos$Seoul$datetime),
                  value = min(dados_meteorologicos$Seoul$datetime),
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
server <- function(input, output, session) {
  
  dados_previstos <- reactive({
    dados <- dados_meteorologicos[[input$cidade]] %>%
      select(datetime, temperature_c, humidity_percent, wind_speed_m_s) %>%
      mutate(
        hour = factor(hour(datetime), levels = 0:23, ordered = TRUE),
        seasons = factor("Spring", levels = c("Winter", "Spring", "Summer", "Autumn")),
        holiday = factor("No Holiday", levels = c("Holiday", "No Holiday"))
      )
    
    predict(modelo_final, new_data = dados) %>%
      bind_cols(dados) %>%
      rename(predito = .pred)
  })
  
  output$mapa <- renderLeaflet({
    cidade_coords <- coords %>% filter(cidade == input$cidade)
    max_prev <- max(dados_previstos()$predito, na.rm = TRUE)
    
    popup_text <- paste0(
      "<b>", input$cidade, "</b><br>",
      "Procura máxima prevista: <b>", round(max_prev), "</b> bicicletas"
    )
    
    leaflet() %>%
      addTiles() %>%
      setView(lng = cidade_coords$lon, lat = cidade_coords$lat, zoom = 11) %>%
      addMarkers(lng = cidade_coords$lon, lat = cidade_coords$lat,
                 popup = popup_text)
  })
  
  output$grafico <- renderPlot({
    dados <- dados_previstos() %>%
      filter(datetime <= input$hora)
    
    if (nrow(dados) >= 2) {
      ggplot(dados, aes(x = datetime, y = predito)) +
        geom_line(color = "steelblue", size = 1.2) +
        geom_point(color = "darkblue") +
        labs(title = paste("Previsão da procura -", input$cidade),
             x = "Data/Hora", y = "Bicicletas Previstas") +
        theme_minimal()
    } else {
      ggplot(dados, aes(x = datetime, y = predito)) +
        geom_point(color = "darkred", size = 3) +
        labs(title = paste("Apenas um ponto disponível -", input$cidade),
             x = "Data/Hora", y = "Bicicletas Previstas") +
        theme_minimal()
    }
  })
}

# ---- Iniciar App ----
shinyApp(ui = ui, server = server)
