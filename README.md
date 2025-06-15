# Projeto SAD – Previsão de Procura por Bicicletas Partilhadas (UAL 2024/2025)

## Descrição do Projeto

Este projeto foi desenvolvido no âmbito da unidade curricular **Sistemas de Apoio à Decisão** (UAL – 2024/2025) e tem como objetivo **prever a procura por bicicletas partilhadas com base em dados meteorológicos reais**.

Foi utilizado um conjunto de dados históricos de Seul, previsões meteorológicas obtidas via API, e informação pública sobre sistemas de partilha de bicicletas. O projeto combina técnicas de **recolha, limpeza, análise, modelação estatística e visualização interativa** através de dashboards em R Shiny.

---

## Estrutura do Projeto

O projeto está organizado da seguinte forma:

- `data_raw/`: Dados brutos recolhidos da API, scraping e datasets externos (.csv)  
- `data_analise/`: Outputs da análise exploratória e transformações (.csv)  
- `graficos/`: Visualizações geradas com ggplot2 (.png)  
- `scripts/`: Scripts em R organizados por fase (recolha, limpeza, EDA, modelação, dashboard)  
- `modelo_final.rds`: Modelo preditivo final treinado com regularização (glmnet)  
- `README.md`: Descrição geral do projeto, instruções e estrutura  
- `Relatorio_Projeto_SAD_UAL_2024-2025.docx`: Documento técnico do projeto

---

## Principais Tecnologias Utilizadas

- **R**, **Posit Cloud**
- Pacotes: `tidyverse`, `tidymodels`, `janitor`, `lubridate`, `stringr`, `ggplot2`, `DBI`, `RSQLite`, `shiny`, `leaflet`, `glmnet`, `httr`, `jsonlite`

---

## Como Executar o Projeto

1. Aceder ao projeto via **Posit Cloud** ou ambiente **R local**.  
2. Executar os scripts na seguinte ordem:

   a. `01_scraping_sistemas_bike.R` – Web scraping da Wikipedia com lista de sistemas de bicicletas  
   b. `02_api_openweather.R` – Recolha de previsões meteorológicas via API para 5 cidades  
   c. `03_limpeza_e_preparacao.R` – Limpeza de dados, padronização de nomes e normalização  
   d. `04_sql_criacao_base.R` – Criação da base de dados SQLite com 4 tabelas (Seoul, sistemas, cidades, previsão)  
   e. `05_eda_sql_queries_avancadas.R` – Execução de queries SQL para análise exploratória  
   f. `06_modelo_tidymodels.R` – Construção do modelo base de regressão linear  
   g. `11_modelo_avancado.R` – Modelos com variáveis temporais, polinómios e regularização (glmnet)  
   h. `12_exportar_modelos.R` – Comparação de previsões e exportação dos modelos  
   i. `13_metricas_comparativas.R` – Geração de gráficos e resumo das métricas  
   j. `07_dashboard_shiny.R` – Execução do dashboard interativo para Seul  
   k. `08_dashboard_multicidade.R` – Execução do dashboard interativo com mapa global  

3. O modelo final (`modelo_final.rds`) é carregado automaticamente pelos dashboards.  
4. Os dados meteorológicos são atualizados dinamicamente com base nos ficheiros `.csv` gerados pela API.

---

## Nota sobre Dados Externos

- **API OpenWeather**:  
  Utilizada para recolher previsões meteorológicas em tempo real para cinco cidades (Seoul, Paris, Londres, Nova Iorque e Suzhou).  

- **Wikipedia – List of Bicycle-Sharing Systems**:  
  Esta página serviu como base para o web scraping de dados globais sobre sistemas de partilha de bicicletas. A informação extraída inclui o nome do sistema, cidade, país, operador, ano de lançamento e status. O scraping foi feito com o pacote `rvest`.

- **Kaggle – Seoul Bike Sharing Demand Dataset**:  
  Este conjunto de dados foi utilizado para treinar e validar os modelos preditivos. Contém dados horários de alugueres de bicicletas em Seul ao longo de um ano, juntamente com variáveis meteorológicas como temperatura, humidade, precipitação, queda de neve e radiação solar.  
  Disponível em:  
  [https://www.kaggle.com/datasets/saurabhshahane/seoul-bike-sharing-demand-prediction](https://www.kaggle.com/datasets/saurabhshahane/seoul-bike-sharing-demand-prediction)

- **World Cities Dataset (Wikipedia/SimpleMaps)**:  
  Utilizado para associar cada sistema de partilha de bicicletas às respetivas coordenadas geográficas e população da cidade correspondente. Este dataset foi incluído como `worldcities.csv`, sendo essencial para a integração com mapas e cálculos de escala urbana no projeto.

## Autores

- **Bilal Nassib** – 300113389  
- **Henrique Monteiro** – 300113382  
- **Luis Raminhas** – 30011447
