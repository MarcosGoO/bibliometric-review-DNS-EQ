# 🚀 GUÍA DE CONFIGURACIÓN - ANÁLISIS BIBLIOMÉTRICO EN R

## REQUISITOS PREVIOS

### ✅ Software necesario:
- **R** (versión 4.0 o superior) - Descargar de: https://cran.r-project.org/
- **RStudio** (versión 2022.07 o superior) - Descargar de: https://posit.co/download/rstudio-desktop/
- **Conexión a internet** para descargar paquetes

### 💾 Espacio en disco:
- Aproximadamente **2-3 GB** para todos los paquetes y sus dependencias

---

## 📋 PASOS DE CONFIGURACIÓN

### PASO 1: Crear Proyecto en RStudio

Ya lo hiciste ✅ - Tienes el proyecto `article_didacsci`

### PASO 2: Organizar estructura de carpetas

En RStudio, ejecuta estos comandos en la consola:

```r
# Crear estructura de carpetas
dir.create("data", showWarnings = FALSE)
dir.create("data/raw", showWarnings = FALSE)
dir.create("data/processed", showWarnings = FALSE)
dir.create("scripts", showWarnings = FALSE)
dir.create("outputs", showWarnings = FALSE)
dir.create("outputs/figuras", showWarnings = FALSE)
dir.create("outputs/tablas", showWarnings = FALSE)
dir.create("outputs/redes", showWarnings = FALSE)
dir.create("outputs/reportes", showWarnings = FALSE)
```

Tu estructura quedará así:
```
article_didacsci/
├── data/
│   ├── raw/                    # .bib originales (Scopus + WoS)
│   └── processed/              # Datos limpios y procesados
├── scripts/                    # Scripts de R
├── outputs/
│   ├── figuras/               # Gráficos PNG/PDF
│   ├── tablas/                # Tablas CSV/Excel
│   ├── redes/                 # Grafos de redes
│   └── reportes/              # Reportes HTML/Word
└── article_didacsci.Rproj     # Tu proyecto
```

### PASO 3: Copiar archivos .bib a la carpeta data/raw

**IMPORTANTE:** Copia manualmente estos archivos:
- `scopus_export_Feb_9-2026_4a282d97-49f3-4a6d-9084-05a1dd2ac18e.bib`
- `savedrecs.bib`

A la carpeta: `data/raw/`

### PASO 4: Ejecutar script de instalación

1. Abre el archivo: `00_instalacion_paquetes.R`
2. Selecciona TODO el código (Ctrl+A / Cmd+A)
3. Ejecuta todo (Ctrl+Enter / Cmd+Enter)
4. **ESPERA** ~5-10 minutos mientras se instalan los paquetes
5. Lee los mensajes en la consola

**⚠️ POSIBLES PROBLEMAS Y SOLUCIONES:**

#### Problema 1: Error "unable to access index for repository"
**Solución:**
```r
options(repos = c(CRAN = "https://cloud.r-project.org/"))
```

#### Problema 2: Paquetes que requieren Rtools (Windows)
Si ves errores sobre "compilation", necesitas **Rtools**:
- Windows: https://cran.r-project.org/bin/windows/Rtools/
- Mac: Instalar Xcode Command Line Tools: `xcode-select --install`
- Linux: `sudo apt-get install r-base-dev`

#### Problema 3: Error con Java (paquetes xlsx antiguos)
**Solución:** Usa `openxlsx` en lugar de `xlsx` (ya viene en el script)

#### Problema 4: Memoria insuficiente
Si tu computadora tiene <8GB RAM, ejecuta:
```r
memory.limit(size = 4000)  # Solo Windows
```

---

## 🧪 VERIFICAR QUE TODO FUNCIONA

Después de la instalación, ejecuta este test rápido:

```r
# Test 1: Cargar paquetes críticos
library(bibliometrix)
library(tidyverse)
library(igraph)
library(tm)
library(topicmodels)

# Test 2: Verificar versiones
packageVersion("bibliometrix")  # Debe ser >= 4.0
packageVersion("tidyverse")      # Debe ser >= 2.0

# Test 3: Test de carga de .bib
ruta_test <- "data/raw/scopus_export_Feb_9-2026_4a282d97-49f3-4a6d-9084-05a1dd2ac18e.bib"

if (file.exists(ruta_test)) {
  cat("✅ Archivo .bib encontrado\n")
  
  # Intentar cargar
  test_data <- convert2df(
    file = ruta_test,
    dbsource = "scopus",
    format = "bibtex"
  )
  
  cat("✅ Carga exitosa:", nrow(test_data), "registros\n")
} else {
  cat("❌ Archivo .bib no encontrado en data/raw/\n")
  cat("   Por favor copia los archivos .bib a esa carpeta\n")
}
```

Si todos los tests pasan ✅, ¡estás listo!

---

## 📝 ORDEN DE EJECUCIÓN DE SCRIPTS

Una vez instalado todo, ejecuta en este orden:

### Fase 1: Diagnóstico y Limpieza
```
01_diagnostico_inicial.R
```
**Tiempo:** ~2-3 minutos  
**Output:** 
- `datos_fusionados.rds`
- Gráficos de tendencia temporal
- Tablas de completitud

### Fase 2A: Análisis Temático (NLP)
```
02A_analisis_tematico_nlp.R
```
**Tiempo:** ~5-10 minutos  
**Output:**
- Topic modeling (LDA)
- Co-ocurrencia de keywords
- Word clouds temáticos
- Sankey diagrams de evolución

### Fase 2B: Análisis de Redes
```
02B_analisis_redes.R
```
**Tiempo:** ~5-10 minutos  
**Output:**
- Redes de co-autoría
- Redes de co-citación
- Clustering de journals
- Mapas de colaboración geográfica

### Fase 2C: Análisis de Impacto
```
02C_analisis_impacto.R
```
**Tiempo:** ~3-5 minutos  
**Output:**
- H-index de autores
- Distribución de citaciones
- Journals de alto impacto
- Sleeping beauties

### Fase 3: Generación de Tablas y Figuras Finales
```
03_figuras_finales_publicacion.R
```
**Tiempo:** ~10-15 minutos  
**Output:**
- 12-15 figuras en alta resolución (300+ DPI)
- Tablas formateadas estilo APA
- Exportación a Word/LaTeX

### Fase 4: Reporte Completo
```
04_reporte_completo.Rmd
```
**Tiempo:** ~5 minutos  
**Output:**
- HTML interactivo
- PDF para revisión
- Word editable

---

## 🎯 CONFIGURACIONES RECOMENDADAS EN RSTUDIO

### 1. Configurar opciones globales:

**Tools → Global Options:**

- **General:**
  - ✅ "Restore .RData into workspace at startup" → **DESACTIVAR**
  - ✅ "Save workspace to .RData on exit" → **Never**

- **Code:**
  - ✅ "Soft-wrap R source files" → **ACTIVAR**
  - ✅ Insert spaces for tab → **2 espacios**

- **Appearance:**
  - Theme: **Cobalt** o **Tomorrow Night Bright** (para trabajar largas horas)

### 2. Instalar extensiones útiles:

```r
# Extensión para formatear código automáticamente
install.packages("styler")

# Extensión para detectar errores antes de ejecutar
install.packages("lintr")
```

### 3. Configurar memoria (si tienes >8GB RAM):

```r
# Al inicio de cada sesión
options(scipen = 999)              # Desactivar notación científica
options(max.print = 100)           # Limitar output en consola
memory.limit(size = 8000)          # Solo Windows - ajustar según tu RAM
```

---

## 🐛 DEBUGGING: Problemas Comunes

### Error: "cannot open the connection"
**Causa:** Ruta incorrecta a los archivos  
**Solución:** 
```r
getwd()  # Ver tu directorio actual
setwd("ruta/a/article_didacsci")  # O usa aquí::here()
```

### Error: "objeto no encontrado"
**Causa:** No ejecutaste los scripts en orden  
**Solución:** Ejecutar script anterior primero

### Error: "no package called 'X'"
**Causa:** Paquete no instalado  
**Solución:**
```r
install.packages("nombre_del_paquete")
```

### Advertencia: "non-UTF-8 strings"
**Causa:** Caracteres especiales en .bib  
**Solución:** Ya está manejado en los scripts (encoding = "UTF-8")

### R se congela / no responde
**Causa:** Análisis computacionalmente intensivo  
**Solución:** 
- Espera (puede tomar minutos)
- Reduce `max_results` en topic modeling
- Cierra otras aplicaciones

---

## 📞 AYUDA ADICIONAL

### Recursos útiles:
- **Documentación bibliometrix:** https://www.bibliometrix.org/
- **ggplot2 cheatsheet:** https://rstudio.github.io/cheatsheets/data-visualization.pdf
- **Tidyverse guide:** https://www.tidyverse.org/learn/

### Comunidad:
- Stack Overflow: https://stackoverflow.com/questions/tagged/r
- RStudio Community: https://community.rstudio.com/

---

## ✅ CHECKLIST FINAL ANTES DE EMPEZAR

- [ ] R versión 4.0+ instalado
- [ ] RStudio instalado
- [ ] Proyecto `article_didacsci` creado
- [ ] Estructura de carpetas creada
- [ ] Archivos .bib copiados a `data/raw/`
- [ ] Script `00_instalacion_paquetes.R` ejecutado exitosamente
- [ ] Test de verificación pasado ✅
- [ ] Configuraciones de RStudio ajustadas

---

**🎉 Si completaste todo el checklist, ¡estás listo para comenzar el análisis!**

**Próximo paso:** Ejecutar `01_diagnostico_inicial.R`
