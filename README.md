
# Projeto SAD – Previsão de Procura em Sistemas de Bicicletas Partilhadas

Este projeto tem como objetivo prever a procura de bicicletas de partilha em várias cidades com base em dados meteorológicos, usando análise de dados, SQL, modelação preditiva e dashboards interativos com R Shiny.

## Tecnologias e Pacotes Usados

- Linguagem: R
- Ambiente: RStudio (Posit Cloud)
- Base de dados: SQLite
- Dashboards: Shiny + Leaflet
- Pacotes principais: `tidyverse`, `tidymodels`, `janitor`, `ggplot2`, `DBI`, `readr`

## Estrutura do Projeto

```
Projeto_SAD/
├── scripts/               # Scripts .R numerados por fase
│   ├── 01_web_scraping_bikes.R
│   ├── 02_api_previsoes_multicidade.R
│   ├── ...
│   └── 08_dashboard_multicidades.R
├── data_raw/             # Dados meteorológicos e históricos
│   ├── bike_project.db       # Base de dados SQLite com tabelas importadas
│   ├── forecast_paris.csv
│   ├── ...
│   └── raw_seoul_bike_sharing.csv
├── real_vs_previsao.png  # Gráfico do modelo
├── Relatorio_SAD_Projeto_Bicicletas.pdf
└── README.md             # Este ficheiro
```

## Como Executar o Projeto

1. Abrir o projeto no RStudio (local ou Posit Cloud)
2. Executar os scripts por ordem (01 a 06) para:
   - Recolher e limpar dados
   - Criar e treinar o modelo
   - Exportar o gráfico de avaliação

3. Para correr os dashboards:
```r
# Para ver o painel de Seoul:
shiny::runApp("scripts/07_dashboard_shiny.R")

# Para ver o painel multicidade:
shiny::runApp("scripts/08_dashboard_multicidades.R")
```

## Comandos principais usados

### Web scraping:
```r
read_html("https://en.wikipedia.org/...") %>%
  html_nodes("table") %>%
  html_table()
```

### API OpenWeather:
```r
GET(url) %>%
  content("text") %>%
  fromJSON()
```
### Base de dados:
## https://www.kaggle.com/datasets/saurabhshahane/seoul-bike-sharing-demand-prediction

### SQL:
```r
dbGetQuery(con, "
  SELECT seasons, AVG(rented_bike_count)
  FROM seoul_bike
  GROUP BY seasons
")
```

### Modelação:
```r
modelo_final <- workflow() %>%
  add_recipe(recipe(...) %>% step_normalize(...)) %>%
  add_model(linear_reg()) %>%
  fit(data = train_data)
```

## 👥 Autores

- Bilal Nassib – 300113389  
- Henrique Monteiro – 300113382  
- Luis Raminhas – 30011447
