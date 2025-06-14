library(httr)
library(jsonlite)

# A tua API Key
api_key <- "224c73c1231cc12fe453208baa695a7a"

# Coordenadas das cidades
cidades <- data.frame(
  nome = c("New_York", "Paris", "Suzhou", "London"),
  lat = c(40.7128, 48.8566, 31.2989, 51.5074),
  lon = c(-74.0060, 2.3522, 120.5853, -0.1278)
)

# Função segura para obter e guardar previsão
obter_previsao <- function(nome, lat, lon) {
  url <- paste0("https://api.openweathermap.org/data/2.5/forecast?lat=", lat,
                "&lon=", lon, "&appid=", api_key, "&units=metric")
  
  resposta <- GET(url)
  
  if (status_code(resposta) == 200) {
    dados <- fromJSON(content(resposta, "text", encoding = "UTF-8"))
    previsoes <- dados$list
    
    clima_df <- data.frame(
      datetime    = previsoes$dt_txt,
      temperatura = previsoes$main$temp,
      humidade    = previsoes$main$humidity,
      vento       = previsoes$wind$speed,
      descricao = sapply(previsoes$weather, function(w) w$description[1])
    )
    
    # Guardar em ficheiro
    nome_arquivo <- paste0("forecast_", nome, ".csv")
    write.csv(clima_df, nome_arquivo, row.names = FALSE)
    print(paste("✅ Guardado:", nome_arquivo))
    head(clima_df)
  } else {
    print(paste("❌ Erro ao obter dados para:", nome))
  }
}

# Executar para todas as cidades
for (i in 1:nrow(cidades)) {
  obter_previsao(cidades$nome[i], cidades$lat[i], cidades$lon[i])
}
