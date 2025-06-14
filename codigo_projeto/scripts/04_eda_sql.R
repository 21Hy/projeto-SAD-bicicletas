# ---- 04_eda_sql.R ----
# Preparação dos dados e criação da base SQLite

# ---- Carregar pacotes ----
library(DBI)
library(RSQLite)
library(dplyr)
library(readr)
library(janitor)

# ---- Eliminar base antiga, se existir ----
if (file.exists("data_raw/bike_project.db")) {
  file.remove("data_raw/bike_project.db")
  cat("🧹 Base de dados antiga removida.\n")
}

# ---- Criar ligação SQLite ----
con <- dbConnect(SQLite(), "data_raw/bike_project.db")

# ---- Ler e limpar dados de Seoul ----
seoul <- read_csv("data_raw/raw_seoul_bike_sharing.csv",
                  locale = locale(encoding = "UTF-8"),
                  show_col_types = FALSE)

seoul <- seoul %>%
  janitor::clean_names()  # limpeza automática dos nomes

# ---- Ler e limpar dados do sistema de bicicletas ----
sistemas <- read_csv("data_raw/clean_bike_sharing_systems.csv", show_col_types = FALSE)

sistemas <- sistemas %>%
  janitor::clean_names()  # limpeza para evitar erros no SQL

# ---- Gravar tabelas na base de dados ----
dbWriteTable(con, "seoul_bike", seoul, overwrite = TRUE)
dbWriteTable(con, "sistemas_bike", sistemas, overwrite = TRUE)

cat("✅ Dados importados com sucesso para SQLite!\n")

# ---- Verificar tabelas e colunas ----
print(dbListTables(con))
print(colnames(seoul))
print(colnames(sistemas))

# ---- Consulta simples para validar ----
print(dbGetQuery(con, "SELECT COUNT(*) AS total_registos FROM seoul_bike"))

