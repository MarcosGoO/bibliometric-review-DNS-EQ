################################################################################
# INSTALACIÓN DE PAQUETES PARA ANÁLISIS BIBLIOMÉTRICO
# Ejecutar UNA SOLA VEZ antes del análisis principal
# Tiempo estimado: 5-10 minutos (dependiendo de tu conexión)
################################################################################

cat("CONFIGURACIÓN DE ENTORNO R PARA ANÁLISIS BIBLIOMÉTRICO\n")

# ==============================================================================
# 1. CONFIGURAR REPOSITORIO CRAN
# ==============================================================================

cat("Configurando repositorio CRAN...\n")
options(repos = c(CRAN = "https://cloud.r-project.org/"))

# ==============================================================================
# 2. LISTA COMPLETA DE PAQUETES NECESARIOS
# ==============================================================================

paquetes_core <- c(
  # === BIBLIOMETRÍA ===
  "bibliometrix",        # Análisis bibliométrico principal
  "dimensionsR",         # Métricas alternativas (opcional)
  
  # === MANIPULACIÓN DE DATOS ===
  "tidyverse",          # Suite completa: dplyr, ggplot2, tidyr, readr, etc.
  "data.table",         # Manipulación rápida de datos grandes
  "janitor",            # Limpieza de nombres de columnas
  
  # === PROCESAMIENTO DE TEXTO / NLP ===
  "tm",                 # Text mining
  "SnowballC",          # Stemming
  "wordcloud",          # Word clouds
  "RColorBrewer",       # Paletas de colores
  "quanteda",           # Análisis cuantitativo de texto
  "topicmodels",        # LDA topic modeling
  "ldatuning",          # Optimización de número de topics
  "stm",                # Structural topic modeling
  "text2vec",           # Word embeddings
  
  # === ANÁLISIS DE REDES ===
  "igraph",             # Análisis de redes
  "ggraph",             # Visualización de redes con ggplot2
  "tidygraph",          # Manipulación de redes con tidyverse
  "networkD3",          # Gráficos de red interactivos
  "visNetwork",         # Visualización interactiva de redes
  
  # === VISUALIZACIÓN AVANZADA ===
  "ggplot2",            # Gráficos core (viene en tidyverse)
  "patchwork",          # Combinar múltiples plots
  "ggrepel",            # Etiquetas sin solapamiento
  "ggthemes",           # Temas adicionales para ggplot2
  "viridis",            # Paletas de colores científicas
  "scales",             # Formateo de escalas
  "ggpubr",             # Publicación-ready plots
  "cowplot",            # Combinar plots estilo publicación
  "gganimate",          # Animaciones (opcional)
  "plotly",             # Gráficos interactivos
  "ggalluvial",         # Sankey/Alluvial diagrams
  "circlize",           # Chord diagrams
  "treemap",            # Tree maps
  "ggwordcloud",        # Word clouds con ggplot2
  
  # === ESTADÍSTICA ===
  "Hmisc",              # Estadísticas descriptivas avanzadas
  "psych",              # Análisis psicométrico
  "FactoMineR",         # PCA y análisis factorial
  "factoextra",         # Visualización de PCA
  
  # === EXPORTACIÓN ===
  "openxlsx",           # Excel (moderno, sin Java)
  "writexl",            # Excel alternativo
  "knitr",              # Reportes dinámicos
  "kableExtra",         # Tablas formateadas
  "flextable",          # Tablas flexibles para Word/PowerPoint
  "officer",            # Exportar a Word/PowerPoint
  "gt",                 # Grammar of tables
  "DT",                 # Tablas interactivas HTML
  
  # === UTILIDADES ===
  "here",               # Manejo de rutas relativas
  "glue",               # String interpolation
  "lubridate",          # Manejo de fechas
  "stringr"             # Manipulación de strings (viene en tidyverse)
)

# ==============================================================================
# 3. FUNCIÓN DE INSTALACIÓN INTELIGENTE
# ==============================================================================

instalar_con_progreso <- function(paquete) {
  if (!require(paquete, character.only = TRUE, quietly = TRUE)) {
    cat(sprintf("Instalando: %s\n", paquete))
    tryCatch({
      install.packages(paquete, dependencies = TRUE, quiet = FALSE)
      library(paquete, character.only = TRUE)
      cat(sprintf("    %s instalado correctamente\n", paquete))
      return(TRUE)
    }, error = function(e) {
      cat(sprintf("    Error instalando %s: %s\n", paquete, e$message))
      return(FALSE)
    })
  } else {
    cat(sprintf("✓ %s ya está instalado\n", paquete))
    return(TRUE)
  }
}

# ==============================================================================
# 4. INSTALACIÓN PROGRESIVA
# ==============================================================================

cat("\nIniciando instalación de", length(paquetes_core), "paquetes...\n")

# Contador de éxito/fallo
exitos <- 0
fallos <- 0
paquetes_fallidos <- c()

# Instalar cada paquete con feedback
for (i in seq_along(paquetes_core)) {
  paquete <- paquetes_core[i]
  cat(sprintf("\n[%d/%d] ", i, length(paquetes_core)))
  
  if (instalar_con_progreso(paquete)) {
    exitos <- exitos + 1
  } else {
    fallos <- fallos + 1
    paquetes_fallidos <- c(paquetes_fallidos, paquete)
  }
  
  # Pequeña pausa para no saturar CRAN
  Sys.sleep(0.5)
}

# ==============================================================================
# 5. REPORTE FINAL
# ==============================================================================

cat("\n")
cat("REPORTE DE INSTALACIÓN\n")
cat("="*80, "\n")
cat(sprintf(" Exitosos: %d/%d\n", exitos, length(paquetes_core)))
cat(sprintf(" Fallidos: %d/%d\n", fallos, length(paquetes_core)))

if (fallos > 0) {
  cat("\nPaquetes que fallaron:\n")
  for (pkg in paquetes_fallidos) {
    cat(sprintf("   - %s\n", pkg))
  }
  cat("\nSOLUCIÓN: Intenta instalar los fallidos manualmente:\n")
  cat(sprintf('   install.packages(c("%s"))\n', 
              paste(paquetes_fallidos, collapse = '", "')))
}

# ==============================================================================
# 6. VERIFICACIÓN DE PAQUETES CRÍTICOS
# ==============================================================================

cat("\nVerificando paquetes críticos...\n")

paquetes_criticos <- c("bibliometrix", "tidyverse", "igraph", "tm", "topicmodels")
todos_ok <- TRUE

for (pkg in paquetes_criticos) {
  if (require(pkg, character.only = TRUE, quietly = TRUE)) {
    cat(sprintf(" %s: OK\n", pkg))
  } else {
    cat(sprintf(" %s: FALTA\n", pkg))
    todos_ok <- FALSE
  }
}

# ==============================================================================
# 7. TEST RÁPIDO DE BIBLIOMETRIX
# ==============================================================================

if (require("bibliometrix", quietly = TRUE)) {
  cat("\nProbando bibliometrix...\n")
  tryCatch({
    # Test simple
    data(scientometrics, package = "bibliometrixData")
    cat(" bibliometrix funciona correctamente\n")
  }, error = function(e) {
    cat("bibliometrix instalado pero puede tener problemas:\n")
    cat("   ", e$message, "\n")
  })
}

# ==============================================================================
# 8. INSTRUCCIONES FINALES
# ==============================================================================

cat("\n")
if (todos_ok && fallos == 0) {
  cat("¡INSTALACIÓN COMPLETADA EXITOSAMENTE!\n")
  cat("="*80, "\n")
  cat("\n Tu entorno R está listo para el análisis bibliométrico.\n")
  cat("\nPRÓXIMOS PASOS:\n")
  cat("   1. Cierra este script\n")
  cat("   2. Abre '01_diagnostico_inicial.R'\n")
  cat("   3. Ejecuta el análisis completo\n")
  cat("\nTIP: Guarda este script por si necesitas reinstalar en el futuro\n")
} else {
  cat("INSTALACIÓN COMPLETADA CON ADVERTENCIAS\n")
  cat("="*80, "\n")
  cat("\nAlgunos paquetes no se instalaron. Puedes continuar, pero algunas\n")
  cat("funcionalidades pueden no estar disponibles.\n")
  cat("\nOPCIONES:\n")
  cat("   1. Reintentar la instalación de paquetes fallidos manualmente\n")
  cat("   2. Continuar con los paquetes instalados exitosamente\n")
  cat("   3. Buscar ayuda para paquetes específicos que fallaron\n")
}

cat("\n")

# ==============================================================================
# 9. INFORMACIÓN DE SESIÓN (ÚTIL PARA DEBUGGING)
# ==============================================================================

cat("\n📋 INFORMACIÓN DE TU SESIÓN R:\n")

print(sessionInfo())

# ==============================================================================
# FIN DEL SCRIPT DE INSTALACIÓN
# ==============================================================================
