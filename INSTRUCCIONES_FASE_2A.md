# 📋 INSTRUCCIONES - FASE 2A: ANÁLISIS TEMÁTICO (NLP)

## ✅ SCRIPT GENERADO

He creado el script completo: `scripts/02A_analisis_tematico_NLP.R`

Este script implementa todas las funcionalidades necesarias para la Fase 2A según las especificaciones técnicas.

---

## 🎯 ¿QUÉ HACE ESTE SCRIPT?

### 1. **Preprocesamiento de Texto**
- Carga los 335 documentos de `outputs/datos_fusionados.csv`
- Limpia abstracts (minúsculas, sin puntuación, sin stopwords)
- Aplica stemming para normalizar términos
- Crea Document-Term Matrix (DTM) filtrada
- Guarda: `data/processed/corpus_cleaned.rds` y `dtm_filtered.rds`

### 2. **Extracción de Keywords con TF-IDF**
- Calcula scores TF-IDF para cada término
- Extrae top 10 keywords por documento
- Combina con keywords originales (cuando existen)
- **SOLUCIONA** el problema de 60% sin keywords → **100% cobertura**
- Guarda: tablas con rankings y estadísticas

### 3. **Topic Modeling con LDA**
- **Optimiza** número de topics (k) entre 5-12 usando métricas:
  - CaoJuan2009 (minimizar)
  - Arun2010 (minimizar)
  - Deveaud2014 (maximizar)
- Entrena modelo LDA con parámetros optimizados
- Asigna topic dominante a cada documento
- Propone etiquetas interpretables para cada topic
- Guarda: `data/processed/lda_model.rds`

### 4. **Genera 6 Visualizaciones Innovadoras**
1. **Topics Heatmap Temporal** - Evolución de topics por año (2016-2026)
2. **Alluvial Diagram** - Flujo de topics: Pre-COVID → Durante → Post-COVID
3. **Word Clouds por Topic** - Grid con cloud de cada topic
4. **Keywords Co-occurrence Network** - Red de co-apariciones con clusters
5. **Trend Topics Timeline** - Líneas temporales de proporción por topic
6. **LDA Optimization Metrics** - Gráfico de métricas para selección de k

### 5. **Tablas de Validación**
- Estadísticas de preprocesamiento
- Cobertura de keywords (original vs. extraída)
- Top 50 keywords globales por TF-IDF
- Descripción detallada de cada topic
- Coherence scores (métrica de calidad)
- Distribución de documentos por topic
- Topics por año (tabla pivotada)

---

## 🚀 CÓMO EJECUTAR

### Opción A: Desde RStudio (Recomendado)

1. **Abre RStudio**
2. **Abre el proyecto**: `article_didacsci.Rproj`
3. **Abre el script**: `scripts/02A_analisis_tematico_NLP.R`
4. **Ejecuta todo el script**:
   - Click en "Source" (ejecuta todo)
   - O selecciona todo (Ctrl+A) y Ctrl+Enter

### Opción B: Desde consola R

```r
setwd("c:/Users/marco/Documents/PROYECTOS/PORTFOLIO/article-didaccnat/article_didacsci")
source("scripts/02A_analisis_tematico_NLP.R")
```

---

## ⏱️ TIEMPO DE EJECUCIÓN

**Estimado: 10-20 minutos** (depende de tu CPU)

- Preprocesamiento: ~2 min
- TF-IDF: ~1 min
- **Optimización de k (LDA): ~5-10 min** ← parte más lenta
- Entrenamiento LDA final: ~3 min
- Visualizaciones: ~2 min

### ⚡ Acelerar si es necesario

Si quieres hacer una prueba rápida, en el script busca esta línea (aprox línea 270):

```r
result_k <- FindTopicsNumber(
```

Y **comenta todo ese bloque** hasta `optimal_k <- result_k$topics[...]`

Luego **descomenta** esta línea:
```r
# optimal_k <- 8
```

Esto usará directamente k=8 sin optimizar (ahorra ~10 minutos).

---

## 📦 PAQUETES NECESARIOS

El script instalará automáticamente todos los paquetes que falten:

**Core NLP:**
- `tm`, `SnowballC`, `quanteda`, `topicmodels`, `ldatuning`, `textclean`, `stringr`

**Visualización:**
- `tidyverse`, `wordcloud`, `ggwordcloud`, `ggalluvial`, `viridis`, `scales`, `patchwork`, `ggrepel`

**Redes:**
- `igraph`, `ggraph`, `tidygraph`

**Export:**
- `openxlsx`, `htmlwidgets`

Si hay algún error de instalación, ejecuta manualmente:
```r
install.packages("nombre_del_paquete")
```

---

## 📂 ARCHIVOS QUE SE GENERARÁN

```
data/processed/
├── corpus_cleaned.rds
├── dtm_filtered.rds
├── lda_model.rds
└── datos_con_topics_y_keywords.csv  ← PRINCIPAL (dataset enriquecido)

outputs/figuras/tematicas/
├── 00_lda_optimization_metrics.png
├── 01_topics_heatmap_temporal.png
├── 02_topics_alluvial_evolution.png
├── 03_wordclouds_por_topic.png
├── 04_keywords_cooccurrence_network.png
└── 05_trend_topics_timeline.png

outputs/tablas/
├── 04_preprocesamiento_estadisticas.csv
├── 05_keywords_coverage.csv
├── 06_top_keywords_tfidf.csv
├── 07_topics_descripcion.csv
├── 08_topics_coherence_scores.csv
├── 09_topics_distribucion.csv
└── 10_topics_por_año.csv
```

---

## ✅ VERIFICAR RESULTADOS

Después de ejecutar, revisa:

### 1. **Visualizaciones**
- Abre `outputs/figuras/tematicas/`
- Verifica que las 6 imágenes PNG se generaron
- Revisa que se vean correctamente (300 DPI)

### 2. **Tablas Clave**
- **`07_topics_descripcion.csv`**: ¿Las etiquetas de topics tienen sentido?
- **`05_keywords_coverage.csv`**: ¿Ahora hay 100% cobertura?
- **`08_topics_coherence_scores.csv`**: ¿Coherence >0.4 para todos los topics?

### 3. **Dataset Enriquecido**
- Abre `data/processed/datos_con_topics_y_keywords.csv`
- Verifica que tiene nuevas columnas:
  - `keywords_tfidf`
  - `keywords_combined`
  - `topic_id`
  - `topic_label`
  - `topic_probability`

---

## 🔧 AJUSTES MANUALES POSIBLES

### Si las etiquetas de topics no son apropiadas:

1. Ejecuta el script una vez
2. Revisa la tabla `07_topics_descripcion.csv`
3. Mira los **Top_10_Terms** de cada topic
4. Edita manualmente las etiquetas en el script (aprox línea 330):

```r
topic_labels <- c(
  "Technology-Enhanced Learning",      # Ajusta según términos observados
  "Inquiry-Based Science Education",
  "Assessment & Evaluation",
  "Teacher Professional Development",
  "STEM Integration",
  "Equity & Social Justice",
  "Environmental Education",
  "Conceptual Understanding"
)[1:optimal_k]
```

5. Re-ejecuta solo desde la sección 5.4 en adelante

---

## ⚠️ POSIBLES ERRORES Y SOLUCIONES

### Error: "No se encuentra outputs/datos_fusionados.csv"
**Solución**: Ejecuta primero `scripts/01_diagnostico_inicial_ACTUALIZADO.R`

### Error: Paquete X no se puede instalar
**Solución**:
```r
install.packages("X", dependencies = TRUE, repos = "https://cloud.r-project.org")
```

### Error: "cannot allocate vector of size..."
**Solución**: Tu PC tiene poca RAM. Reduce el corpus:
```r
df_trabajo <- df_trabajo %>% sample_n(200)  # Usa solo 200 docs para prueba
```

### Warning: "NAs introduced by coercion"
**Solución**: Es normal en algunos pasos de limpieza, el script lo maneja automáticamente.

---

## 📊 INTERPRETACIÓN DE RESULTADOS

### Coherence Score (métrica de calidad LDA)
- **< 0.4**: Topics poco coherentes, considera ajustar k
- **0.4 - 0.6**: Aceptable para análisis exploratorio
- **> 0.6**: Excelente, topics bien definidos

### Número de Topics (k)
- **k muy bajo (5-6)**: Topics muy generales
- **k óptimo (7-9)**: Balance entre granularidad e interpretabilidad
- **k muy alto (>10)**: Topics muy específicos, difíciles de interpretar

### Distribución de Documentos
- **Ideal**: Distribución relativamente uniforme (cada topic 8-15%)
- **Problema**: Un topic domina >40% → revisar preprocesamiento

---

## 🎯 CRITERIOS DE ÉXITO

Fase 2A será exitosa si:

✅ **Coverage de keywords: 100%** (vs 40% original)
✅ **Coherence promedio: >0.4**
✅ **Todos los topics tienen >5% documentos** (no hay topics "huérfanos")
✅ **Etiquetas de topics son interpretables** y reflejan la literatura
✅ **Visualizaciones se generan sin errores** (300 DPI, legibles)
✅ **Dataset enriquecido tiene >335 filas** con todas las columnas nuevas

---

## 📝 NOTAS IMPORTANTES

1. **Seed fijada (12345)**: Garantiza reproducibilidad. Mismos resultados en cada ejecución.

2. **Año 2026 parcial**: El script excluye 2026 de tendencias (solo 13 docs).

3. **Stopwords personalizadas**: Incluye términos muy genéricos del dominio. Ajusta si es necesario.

4. **Stemming en inglés**: Si tienes muchos docs en español, considera ajustar:
   ```r
   tm_map(stemDocument, language = "spanish")
   ```

5. **TF-IDF vs Keywords originales**: El script **combina** ambos para maximizar cobertura.

---

## 🚀 DESPUÉS DE EJECUTAR

1. **Revisa visualizaciones** en `outputs/figuras/tematicas/`
2. **Valida topics** en tabla `07_topics_descripcion.csv`
3. **Ajusta etiquetas** si es necesario y re-ejecuta última sección
4. **Guarda progreso** (commit en Git)
5. **Continúa con Fase 2B**: Análisis de Redes

---

## 📧 PREGUNTAS FRECUENTES

**P: ¿Puedo cambiar el número de keywords extraídas por documento?**
R: Sí, busca `n_keywords <- 10` (línea ~172) y ajusta el valor.

**P: ¿Puedo usar solo keywords originales sin TF-IDF?**
R: Sí, pero tendrás 60% documentos sin keywords. No recomendado.

**P: ¿Cuántos topics debería usar?**
R: Deja que el script optimice automáticamente. Típicamente 7-9 es óptimo.

**P: ¿Puedo ejecutar esto en una laptop con 4GB RAM?**
R: Sí, pero reduce el corpus para pruebas iniciales (ver sección de errores).

---

**Fecha de creación**: Febrero 9, 2026
**Script**: `scripts/02A_analisis_tematico_NLP.R`
**Estado**: ✅ Listo para ejecutar
