library(httr)
library(jsonlite)

# Substitui aqui pela tua chave real
api_key <- "224c73c1231cc12fe453208baa695a7a"

# Coordenadas de Paris
lat <- 48.8566
lon <- 2.3522

# Montar URL
url <- paste0("https://api.openweathermap.org/data/2.5/forecast?lat=", lat,
              "&lon=", lon, "&appid=", api_key, "&units=metric")

# Fazer pedido
resposta <- GET(url)

# Verificar status
print(status_code(resposta))

# Mostrar o conteúdo da resposta
json_bruto <- content(resposta, "text", encoding = "UTF-8")
cat(substr(json_bruto, 1, 1000))  # Mostra os primeiros 1000 caracteres do JSON
