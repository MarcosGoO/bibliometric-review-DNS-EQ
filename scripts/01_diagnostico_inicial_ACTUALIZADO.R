################################################################################
# ANÁLISIS BIBLIOMÉTRICO: DIDÁCTICA DE CIENCIAS NATURALES Y CALIDAD EDUCATIVA
# Fase 1: Diagnóstico Inicial y Limpieza de Datos
# Autor: [Tu nombre]
# Fecha: Febrero 2026
################################################################################

# ==============================================================================
# 1. INSTALACIÓN Y CARGA DE PAQUETES
# ==============================================================================

# Lista de paquetes necesarios
paquetes_necesarios <- c(
  "bibliometrix",    # Core bibliometrics
  "tidyverse",       # Data manipulation
  "openxlsx",        # Excel export
  "knitr",           # Reports
  "kableExtra",      # Tables formatting
  "dimensionsR",     # Alternative metrics (opcional)
  "igraph",          # Network analysis
  "ggplot2",         # Advanced plots
  "ggraph",          # Network visualization
  "viridis",         # Color palettes
  "patchwork",       # Combine plots
  "wordcloud2"       # Word clouds (opcional)
)

# Función para instalar paquetes faltantes
instalar_si_falta <- function(paquete) {
  if (!require(paquete, character.only = TRUE)) {
    install.packages(paquete, dependencies = TRUE)
    library(paquete, character.only = TRUE)
  }
}

# Instalar y cargar todos los paquetes
cat("Instalando paquetes necesarios...\n")
invisible(sapply(paquetes_necesarios, instalar_si_falta))
cat("Todos los paquetes cargados exitosamente\n\n")

# ==============================================================================
# 2. CONFIGURACIÓN DE RUTAS Y PARÁMETROS
# ==============================================================================

# Definir rutas relativas al proyecto (NO necesitas cambiar nada si seguiste la guía)
# El proyecto debe tener esta estructura:
# article_didacsci/
#   ├── data/raw/         <- Aquí van los .bib
#   ├── outputs/          <- Aquí se guardan resultados
#   └── scripts/          <- Aquí van los scripts .R

ruta_scopus <- "data/raw/scopus_export_Feb_9-2026_4a282d97-49f3-4a6d-9084-05a1dd2ac18e.bib"
ruta_wos <- "data/raw/savedrecs.bib"

# Verificar que los archivos existen
if (!file.exists(ruta_scopus)) {
  stop("ERROR: No se encuentra el archivo de Scopus en data/raw/
       Por favor copia 'scopus_export_Feb_9-2026_4a282d97-49f3-4a6d-9084-05a1dd2ac18e.bib' a la carpeta data/raw/")
}

if (!file.exists(ruta_wos)) {
  stop("ERROR: No se encuentra el archivo de WoS en data/raw/
       Por favor copia 'savedrecs.bib' a la carpeta data/raw/")
}

# Crear estructura de carpetas para resultados (si no existe)
dir.create("outputs", showWarnings = FALSE)
dir.create("outputs/figuras", showWarnings = FALSE)
dir.create("outputs/tablas", showWarnings = FALSE)
dir.create("outputs/redes", showWarnings = FALSE)
dir.create("data/processed", showWarnings = FALSE)

# ==============================================================================
# 3. CARGA DE ARCHIVOS .BIB
# ==============================================================================

cat("Cargando archivos bibliográficos...\n")

# Cargar archivo de Scopus
tryCatch({
  scopus_data <- convert2df(
    file = ruta_scopus,
    dbsource = "scopus",
    format = "bibtex"
  )
  cat("Scopus cargado:", nrow(scopus_data), "registros\n")
}, error = function(e) {
  cat("Error al cargar Scopus:", e$message, "\n")
  stop("Verifica la ruta del archivo de Scopus")
})

# Cargar archivo de Web of Science
tryCatch({
  wos_data <- convert2df(
    file = ruta_wos,
    dbsource = "wos",
    format = "bibtex"
  )
  cat("WoS cargado:", nrow(wos_data), "registros\n")
}, error = function(e) {
  cat(" Error al cargar WoS:", e$message, "\n")
  stop("Verifica la ruta del archivo de WoS")
})

# ==============================================================================
# 4. FUSIÓN Y ELIMINACIÓN DE DUPLICADOS
# ==============================================================================

cat("\nFusionando bases de datos y eliminando duplicados...\n")

# Fusionar ambas bases
M <- mergeDbSources(scopus_data, wos_data, remove.duplicated = TRUE)

# Reporte de fusión
cat("\nRESUMEN DE FUSIÓN:\n")
cat("   - Registros Scopus:", nrow(scopus_data), "\n")
cat("   - Registros WoS:", nrow(wos_data), "\n")
cat("   - Total antes de fusión:", nrow(scopus_data) + nrow(wos_data), "\n")
cat("   - Total después de fusión:", nrow(M), "\n")
cat("   - Duplicados eliminados:", 
    (nrow(scopus_data) + nrow(wos_data)) - nrow(M), "\n")
cat("   - Tasa de solapamiento:", 
    round(((nrow(scopus_data) + nrow(wos_data)) - nrow(M)) / 
          (nrow(scopus_data) + nrow(wos_data)) * 100, 2), "%\n\n")

# ==============================================================================
# 5. ANÁLISIS DESCRIPTIVO INICIAL
# ==============================================================================

cat("Generando estadísticas descriptivas...\n")

# Análisis bibliométrico básico
resultados <- biblioAnalysis(M, sep = ";")

# Resumen estadístico
cat("\n" , "="*80, "\n")
cat("ESTADÍSTICAS DESCRIPTIVAS DEL CORPUS\n")
cat("="*80, "\n\n")

summary(object = resultados, k = 10, pause = FALSE)

# ==============================================================================
# 6. CALIDAD DE DATOS: CAMPOS COMPLETOS
# ==============================================================================

cat("\n🔍 Evaluando completitud de campos clave...\n")

# Función para calcular % de completitud
calcular_completitud <- function(campo) {
  sum(!is.na(campo) & campo != "") / length(campo) * 100
}

# Campos críticos para evaluar
campos_criticos <- c("TI", "AU", "SO", "PY", "AB", "DE", "ID", "TC", "DI")
nombres_campos <- c("Título", "Autores", "Journal", "Año", "Abstract", 
                   "Keywords Autor", "Keywords Plus", "Citaciones", "DOI")

completitud <- data.frame(
  Campo = nombres_campos,
  Porcentaje = sapply(campos_criticos, function(x) {
    if(x %in% names(M)) {
      calcular_completitud(M[[x]])
    } else {
      0
    }
  })
)

completitud <- completitud %>%
  arrange(desc(Porcentaje)) %>%
  mutate(Estado = case_when(
    Porcentaje >= 90 ~ "Excelente",
    Porcentaje >= 70 ~ "Bueno",
    Porcentaje >= 50 ~ "Regular",
    TRUE ~ "Deficiente"
  ))

print(completitud)

# Guardar tabla de completitud
write.csv(completitud, "outputs/tablas/01_completitud_campos.csv", 
          row.names = FALSE)

# ==============================================================================
# 7. DISTRIBUCIÓN TEMPORAL
# ==============================================================================

cat("\nAnalizando distribución temporal...\n")

# Crear tabla de producción por año
produccion_anual <- M %>%
  filter(!is.na(PY)) %>%
  count(PY) %>%
  arrange(PY) %>%
  rename(Año = PY, Documentos = n) %>%
  mutate(
    Crecimiento = c(NA, diff(Documentos)),
    Tasa_Crecimiento = round(Crecimiento / lag(Documentos) * 100, 1)
  )

# Visualización
p1 <- ggplot(produccion_anual, aes(x = Año, y = Documentos)) +
  geom_line(color = "#2C3E50", size = 1) +
  geom_point(color = "#E74C3C", size = 3) +
  geom_smooth(method = "loess", se = TRUE, color = "#3498DB", alpha = 0.2) +
  theme_minimal() +
  labs(
    title = "Producción Científica Anual (2016-2026)",
    subtitle = paste("Total:", nrow(M), "documentos"),
    x = "Año",
    y = "Número de Publicaciones"
  ) +
  theme(
    plot.title = element_text(face = "bold", size = 14),
    axis.text.x = element_text(angle = 45, hjust = 1)
  )

ggsave("outputs/figuras/01_produccion_anual.png", p1, 
       width = 10, height = 6, dpi = 300)

# ==============================================================================
# 8. TIPOS DE DOCUMENTOS
# ==============================================================================

cat("\nAnalizando tipos de documentos...\n")

# Distribución por tipo
tipos_doc <- M %>%
  count(DT) %>%
  arrange(desc(n)) %>%
  mutate(
    Porcentaje = round(n / sum(n) * 100, 1),
    Tipo = ifelse(is.na(DT), "NO ESPECIFICADO", DT)
  )

print(tipos_doc)

# Gráfico de tipos de documento
p2 <- ggplot(tipos_doc, aes(x = reorder(Tipo, n), y = n, fill = Tipo)) +
  geom_col(show.legend = FALSE) +
  geom_text(aes(label = paste0(n, " (", Porcentaje, "%)")), 
            hjust = -0.1, size = 3) +
  coord_flip() +
  scale_fill_viridis_d() +
  theme_minimal() +
  labs(
    title = "Distribución por Tipo de Documento",
    x = NULL,
    y = "Número de Documentos"
  ) +
  theme(plot.title = element_text(face = "bold"))

ggsave("outputs/figuras/02_tipos_documento.png", p2, 
       width = 10, height = 6, dpi = 300)

# ==============================================================================
# 9. IDIOMAS DE PUBLICACIÓN
# ==============================================================================

cat("\nAnalizando idiomas...\n")

idiomas <- M %>%
  count(LA) %>%
  arrange(desc(n)) %>%
  mutate(
    Porcentaje = round(n / sum(n) * 100, 1),
    Idioma = ifelse(is.na(LA), "NO ESPECIFICADO", LA)
  )

print(head(idiomas, 10))

# ==============================================================================
# 10. JOURNALS MÁS PRODUCTIVOS
# ==============================================================================

cat("\nIdentificando journals más productivos...\n")

top_journals <- M %>%
  filter(!is.na(SO)) %>%
  count(SO) %>%
  arrange(desc(n)) %>%
  head(20) %>%
  rename(Journal = SO, Documentos = n) %>%
  mutate(Porcentaje = round(Documentos / nrow(M) * 100, 2))

print(top_journals)

# Guardar
write.csv(top_journals, "outputs/tablas/02_top_journals.csv", 
          row.names = FALSE)

# ==============================================================================
# 11. PAÍSES MÁS PRODUCTIVOS
# ==============================================================================

cat("\nAnalizando distribución geográfica...\n")

# Extraer países de afiliaciones
paises <- M %>%
  select(AU_CO) %>%
  filter(!is.na(AU_CO)) %>%
  separate_rows(AU_CO, sep = ";") %>%
  mutate(AU_CO = trimws(AU_CO)) %>%
  filter(AU_CO != "") %>%
  count(AU_CO) %>%
  arrange(desc(n)) %>%
  head(20) %>%
  rename(Pais = AU_CO, Documentos = n) %>%
  mutate(Porcentaje = round(Documentos / nrow(M) * 100, 2))

print(paises)

# Gráfico de países
p3 <- ggplot(head(paises, 15), aes(x = reorder(Pais, Documentos), 
                                    y = Documentos, fill = Documentos)) +
  geom_col(show.legend = FALSE) +
  geom_text(aes(label = Documentos), hjust = -0.2, size = 3) +
  coord_flip() +
  scale_fill_viridis_c(option = "plasma") +
  theme_minimal() +
  labs(
    title = "Top 15 Países por Producción Científica",
    x = NULL,
    y = "Número de Documentos"
  ) +
  theme(plot.title = element_text(face = "bold"))

ggsave("outputs/figuras/03_top_paises.png", p3, 
       width = 10, height = 7, dpi = 300)

# ==============================================================================
# 12. GUARDAR DATOS CONSOLIDADOS
# ==============================================================================

cat("\n💾 Guardando datos consolidados...\n")

# Guardar el dataframe fusionado en varios formatos
saveRDS(M, file = "outputs/datos_fusionados.rds")
write.csv(M, "outputs/datos_fusionados.csv", row.names = FALSE)

# Exportar a Excel con múltiples hojas
wb <- createWorkbook()

# Hoja 1: Datos completos
addWorksheet(wb, "Datos_Completos")
writeData(wb, "Datos_Completos", M)

# Hoja 2: Completitud
addWorksheet(wb, "Completitud_Campos")
writeData(wb, "Completitud_Campos", completitud)

# Hoja 3: Producción anual
addWorksheet(wb, "Produccion_Anual")
writeData(wb, "Produccion_Anual", produccion_anual)

# Hoja 4: Top journals
addWorksheet(wb, "Top_Journals")
writeData(wb, "Top_Journals", top_journals)

# Hoja 5: Top países
addWorksheet(wb, "Top_Paises")
writeData(wb, "Top_Paises", paises)

# Guardar Excel
saveWorkbook(wb, "outputs/01_diagnostico_completo.xlsx", overwrite = TRUE)

cat("Archivo Excel guardado: outputs/01_diagnostico_completo.xlsx\n")

# ==============================================================================
# 13. REPORTE FINAL
# ==============================================================================

cat("\n" , "="*80, "\n")
cat("DIAGNÓSTICO INICIAL COMPLETADO\n")
cat("="*80, "\n\n")
cat("Archivos generados:\n")
cat("outputs/datos_fusionados.rds (datos en formato R)\n")
cat("outputs/datos_fusionados.csv (datos en CSV)\n")
cat("outputs/01_diagnostico_completo.xlsx (Excel con múltiples hojas)\n")
cat("outputs/figuras/*.png (3 gráficos)\n")
cat("outputs/tablas/*.csv (2 tablas)\n\n")

cat("PRÓXIMOS PASOS:\n")
cat("  1. Revisar el archivo Excel generado\n")
cat("  2. Verificar gráficos en la carpeta 'figuras'\n")
cat("  3. Ejecutar script 02 para análisis de keywords\n")
cat("  4. Ejecutar script 03 para análisis de co-citación\n\n")

cat("=")

# ==============================================================================
# FIN DEL SCRIPT
# ==============================================================================
