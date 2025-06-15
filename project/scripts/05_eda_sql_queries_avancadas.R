# ---- 05_eda_sql_queries_avancadas.R ----
# Análise exploratória avançada com SQL + R

library(DBI)
library(RSQLite)
library(dplyr)
library(readr)
library(janitor)

# Conectar à base de dados SQLite
con <- dbConnect(SQLite(), "data_raw/bike_project.db")

# ---- Tarefa 7: Temperatura e aluguer médio por hora e estação ----
print(dbGetQuery(con, "
  SELECT 
    seasons,
    hour,
    ROUND(AVG(temperature_c), 2) AS temperatura_media,
    ROUND(AVG(rented_bike_count), 1) AS aluguer_medio
  FROM seoul_bike
  GROUP BY seasons, hour
  ORDER BY aluguer_medio DESC
  LIMIT 10
"))

# ---- Tarefa 8: Média, mínimo, máximo por estação ----
print(dbGetQuery(con, "
  SELECT 
    seasons,
    ROUND(AVG(rented_bike_count), 1) AS media,
    MIN(rented_bike_count) AS minimo,
    MAX(rented_bike_count) AS maximo
  FROM seoul_bike
  GROUP BY seasons
"))

# ---- Tarefa 8B: Desvio padrão no R ----
seoul <- dbReadTable(con, "seoul_bike")
seoul %>%
  group_by(seasons) %>%
  summarise(
    desvio_padrao = round(sd(rented_bike_count), 1)
  ) %>%
  print()

# ---- Tarefa 9: Clima médio por estação + aluguer ----
print(dbGetQuery(con, "
  SELECT 
    seasons,
    ROUND(AVG(temperature_c),1) AS temperatura,
    ROUND(AVG(humidity_percent),1) AS humidade,
    ROUND(AVG(wind_speed_m_s),1) AS vento,
    ROUND(AVG(visibility_10m),1) AS visibilidade,
    ROUND(AVG(dew_point_temperature_c),1) AS ponto_orvalho,
    ROUND(AVG(solar_radiation_mj_m2),1) AS radiacao,
    ROUND(AVG(rainfall_mm),1) AS precipitacao,
    ROUND(AVG(snowfall_cm),1) AS neve,
    ROUND(AVG(rented_bike_count),1) AS aluguer_medio
  FROM seoul_bike
  GROUP BY seasons
  ORDER BY aluguer_medio DESC
"))

# ---- Tarefa 10: Info completa sobre Seul (com junção) ----

# Garantir que a tabela world_cities já existe na base
if (!"world_cities" %in% dbListTables(con)) {
  world_cities <- read_csv("data_raw/worldcities.csv", show_col_types = FALSE) %>%
    janitor::clean_names()
  dbWriteTable(con, "world_cities", world_cities, overwrite = TRUE)
}

# Executar junção implícita entre sistemas_bike e world_cities
resultado <- dbGetQuery(con, "
  SELECT 
    sb.city_region AS cidade,
    sb.country_1 AS pais,
    wc.lat,
    wc.lng AS lon,
    wc.population
  FROM sistemas_bike sb, world_cities wc
  WHERE LOWER(sb.city_region) LIKE '%seoul%'
    AND LOWER(wc.city) = 'seoul'
  LIMIT 1
")

print(resultado)

# Guardar em CSV
write_csv(resultado, "data_analise/tarefa10_join_seoul.csv")

# ---- Tarefa 11: Cidades com sistemas ativos (sem filtro por nº bicicletas) ----
print(dbGetQuery(con, "
  SELECT 
    city_region, country_1, system, operator, launched
  FROM sistemas_bike
  WHERE discontinued IS NULL
  ORDER BY launched
  LIMIT 10
"))
