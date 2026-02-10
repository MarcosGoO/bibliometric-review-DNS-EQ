# 🔧 GUÍA TÉCNICA DE IMPLEMENTACIÓN EN R

## ESPECIFICACIONES TÉCNICAS PARA CLAUDE CODE

---

## 1. ENTORNO Y DEPENDENCIAS

### Paquetes requeridos por fase:

**FASE 2A - Análisis Temático (NLP):**
```r
# Core NLP
library(tm)              # Text mining framework
library(SnowballC)       # Stemming algorithms
library(quanteda)        # Quantitative text analysis
library(topicmodels)     # LDA implementation
library(ldatuning)       # Optimize number of topics
library(text2vec)        # Word embeddings, TF-IDF
library(textclean)       # Text cleaning utilities

# Visualización temática
library(wordcloud)       # Basic word clouds
library(ggwordcloud)     # ggplot2-style word clouds
library(ggalluvial)      # Sankey/alluvial diagrams
library(treemapify)      # Treemaps for hierarchies
```

**FASE 2B - Análisis de Redes:**
```r
# Network analysis
library(igraph)          # Core network analysis
library(ggraph)          # Network visualization with ggplot2
library(tidygraph)       # Tidy manipulation of networks
library(networkD3)       # Interactive network visualizations
library(visNetwork)      # Interactive vis alternative

# Geographic
library(sf)              # Spatial data handling
library(rnaturalearth)   # World maps data
library(rnaturalearthdata)
```

**FASE 2C - Análisis de Impacto:**
```r
# Bibliometric metrics
library(bibliometrix)    # H-index, citations analysis
library(Hmisc)          # Statistical summaries
```

**Visualización general (todas las fases):**
```r
library(tidyverse)       # ggplot2, dplyr, tidyr, etc.
library(patchwork)       # Combine multiple plots
library(cowplot)         # Publication-ready plots
library(ggrepel)         # Non-overlapping labels
library(viridis)         # Colorblind-friendly palettes
library(scales)          # Scale formatting (%, K, M)
library(ggpubr)          # Publication themes
library(ggsci)           # Scientific journal color palettes
```

**Exportación:**
```r
library(openxlsx)        # Excel export
library(officer)         # Word/PowerPoint export
library(flextable)       # Flexible tables for Word
library(gt)              # Grammar of tables
library(knitr)           # Reports
library(rmarkdown)       # Dynamic documents
```

---

## 2. ESTRUCTURA DE DATOS ESPERADA

### Dataset principal: `datos_fusionados.csv`

**Campos existentes (Fase 1):**
```
ID                  - Unique identifier
ENTRYTYPE           - Document type (all "article")
title               - Full title
author              - Authors (separated by "; ")
year                - Publication year
journal             - Journal name
abstract            - Full abstract text
keywords            - Original keywords (40% populated)
doi                 - DOI identifier
affiliations        - Institution affiliations
database            - Source ("Scopus" or "WoS")
title_norm          - Normalized title (for dedup)
```

**Campos a añadir (Fase 2A):**
```
abstract_clean      - Preprocessed abstract (lowercase, no stopwords)
keywords_tfidf      - Extracted keywords via TF-IDF (top 5-10)
keywords_combined   - Original + extracted keywords
topic_lda_id        - Assigned LDA topic (1 to k)
topic_lda_label     - Human-readable topic label
topic_probability   - Probability of dominant topic
```

**Campos a añadir (Fase 2B):**
```
countries           - List of countries (from affiliations)
country_first       - Country of first author
institutions        - List of institutions
coauthors_count     - Number of co-authors
international_collab - TRUE if multi-country
degree_centrality   - Author network degree
betweenness_cent    - Author network betweenness
cluster_id          - Community/cluster assignment
```

**Campos a añadir (Fase 2C):**
```
citations           - Total citations received
citations_per_year  - Citations / years since pub
highly_cited        - TRUE if top 10% by citations
sleeping_beauty     - TRUE if delayed citation pattern
author_hindex       - First author h-index
journal_quartile    - Q1, Q2, Q3, Q4
journal_impact      - Impact factor (if available)
```

---

## 3. PREPROCESAMIENTO DE TEXTO (Fase 2A.1)

### Pipeline estándar:

```r
# Paso 1: Cargar abstracts
abstracts <- df$abstract

# Paso 2: Crear corpus
corpus <- Corpus(VectorSource(abstracts))

# Paso 3: Limpieza secuencial
corpus_clean <- corpus %>%
  tm_map(content_transformer(tolower)) %>%           # Lowercase
  tm_map(removePunctuation) %>%                      # Remove punctuation
  tm_map(removeNumbers) %>%                          # Remove numbers
  tm_map(removeWords, stopwords("english")) %>%      # English stopwords
  tm_map(removeWords, stopwords("spanish")) %>%      # Spanish stopwords
  tm_map(stripWhitespace) %>%                        # Strip whitespace
  tm_map(stemDocument, language = "english")         # Stemming

# Paso 4: Document-Term Matrix
dtm <- DocumentTermMatrix(corpus_clean)

# Paso 5: Filtrar términos raros
# Remover términos que aparecen en <1% o >95% de documentos
dtm_filtered <- removeSparseTerms(dtm, sparse = 0.95)
```

### Stopwords personalizadas (añadir):

```r
custom_stopwords <- c(
  "study", "research", "paper", "article", "journal",
  "education", "educational", "science", "scientific",
  "results", "findings", "analysis", "method",
  "et", "al", "also", "however", "therefore",
  "using", "based", "used", "show", "showed"
)

# Añadir a la limpieza
corpus_clean <- tm_map(corpus_clean, removeWords, custom_stopwords)
```

### Validaciones:

```r
# Verificar vocabulario resultante
vocab <- Terms(dtm_filtered)
cat("Vocabulario final:", length(vocab), "términos\n")

# Verificar distribución de longitud de documentos
doc_lengths <- rowSums(as.matrix(dtm_filtered))
summary(doc_lengths)

# ALERTA: Si mediana < 20 términos, revisar stopwords
# ALERTA: Si vocab > 5000 términos, aumentar sparsity threshold
```

---

## 4. TOPIC MODELING (Fase 2A.3)

### Optimización de k (número de topics):

```r
library(ldatuning)

# Probar rango de k
result <- FindTopicsNumber(
  dtm_filtered,
  topics = seq(from = 5, to = 15, by = 1),
  metrics = c("Griffiths2004", "CaoJuan2009", "Arun2010", "Deveaud2014"),
  method = "Gibbs",
  control = list(seed = 12345),
  mc.cores = 4L,  # Usar 4 cores (ajustar según CPU)
  verbose = TRUE
)

# Visualizar métricas
FindTopicsNumber_plot(result)

# Seleccionar k óptimo
# CRITERIO: Maximizar Griffiths2004 y Deveaud2014
#           Minimizar CaoJuan2009 y Arun2010
optimal_k <- 8  # Ejemplo, ajustar según gráfico
```

### Entrenamiento del modelo LDA:

```r
library(topicmodels)

# Configuración de control
control_LDA_Gibbs <- list(
  seed = 12345,
  burnin = 1000,
  iter = 2000,
  thin = 10,
  alpha = 0.1,  # Dirichlet prior for document-topic
  delta = 0.01  # Dirichlet prior for topic-word
)

# Entrenar modelo
lda_model <- LDA(
  dtm_filtered,
  k = optimal_k,
  method = "Gibbs",
  control = control_LDA_Gibbs
)

# Guardar modelo
saveRDS(lda_model, "outputs/data/processed/lda_model.rds")
```

### Extracción de topics:

```r
# Top términos por topic
topics_terms <- terms(lda_model, 20)  # Top 20 terms per topic

# Probabilidades de topics por documento
doc_topics <- posterior(lda_model)$topics

# Asignar topic dominante a cada documento
dominant_topic <- apply(doc_topics, 1, which.max)
dominant_prob <- apply(doc_topics, 1, max)

# Añadir al dataframe
df$topic_lda_id <- dominant_topic
df$topic_probability <- dominant_prob
```

### Etiquetado manual de topics:

```r
# IMPORTANTE: Revisar términos y asignar etiquetas interpretables
topic_labels <- c(
  "1" = "Technology-Enhanced Learning",
  "2" = "Inquiry-Based Science Education",
  "3" = "Assessment & Evaluation",
  "4" = "Teacher Professional Development",
  "5" = "STEM Integration",
  "6" = "Equity & Inclusion",
  "7" = "Environmental Education",
  "8" = "Conceptual Understanding"
)

df$topic_lda_label <- topic_labels[as.character(df$topic_lda_id)]
```

### Validación del modelo:

```r
# Coherence score (requiere paquete textmineR)
library(textmineR)

coherence <- CalcProbCoherence(
  phi = posterior(lda_model)$terms,
  dtm = dtm_filtered
)

cat("Coherence promedio:", mean(coherence), "\n")
# ESPERADO: > 0.4 es aceptable, > 0.6 es bueno
```

---

## 5. VISUALIZACIONES - ESPECIFICACIONES

### Paleta de colores consistente:

```r
# Usar viridis para todos los gráficos
palette_topics <- viridis(optimal_k, option = "D")
palette_sequential <- viridis(100, option = "C")
palette_diverging <- RColorBrewer::brewer.pal(11, "RdBu")

# Para redes
palette_network <- ggsci::pal_d3("category20")(20)
```

### Tema ggplot2 base:

```r
theme_publication <- theme_minimal() +
  theme(
    text = element_text(family = "Arial", size = 10),
    plot.title = element_text(face = "bold", size = 14, hjust = 0.5),
    plot.subtitle = element_text(size = 10, hjust = 0.5, color = "gray40"),
    axis.title = element_text(face = "bold", size = 11),
    axis.text = element_text(size = 9),
    legend.position = "right",
    legend.title = element_text(face = "bold", size = 10),
    legend.text = element_text(size = 9),
    panel.grid.minor = element_blank(),
    plot.margin = margin(10, 10, 10, 10)
  )

# Aplicar globalmente
theme_set(theme_publication)
```

### Especificaciones de exportación:

```r
# Para PNG (figuras online/suplementarias)
ggsave(
  filename = "output.png",
  plot = p,
  width = 8,
  height = 6,
  units = "in",
  dpi = 300,
  bg = "white"
)

# Para PDF (figuras de manuscrito)
ggsave(
  filename = "output.pdf",
  plot = p,
  width = 8,
  height = 6,
  units = "in",
  device = cairo_pdf  # Mejor manejo de fuentes
)

# Para EPS (algunos journals lo requieren)
ggsave(
  filename = "output.eps",
  plot = p,
  width = 8,
  height = 6,
  units = "in",
  device = cairo_ps
)
```

---

## 6. ANÁLISIS DE REDES - CONSTRUCCIÓN

### Red de co-autoría:

```r
library(igraph)

# Paso 1: Extraer autores
authors_list <- df %>%
  select(ID, author) %>%
  separate_rows(author, sep = "; ") %>%
  mutate(author = trimws(author))

# Paso 2: Crear matriz de adyacencia
# Autores que co-publicaron están conectados
coauthorship <- authors_list %>%
  inner_join(authors_list, by = "ID", suffix = c("_1", "_2")) %>%
  filter(author_1 < author_2) %>%  # Evitar duplicados
  count(author_1, author_2, name = "weight")

# Paso 3: Crear grafo
g_coauth <- graph_from_data_frame(
  coauthorship,
  directed = FALSE,
  vertices = unique(authors_list$author)
)

# Paso 4: Calcular métricas
V(g_coauth)$degree <- degree(g_coauth)
V(g_coauth)$betweenness <- betweenness(g_coauth, normalized = TRUE)
V(g_coauth)$closeness <- closeness(g_coauth, normalized = TRUE)

# Paso 5: Detectar comunidades
communities <- cluster_louvain(g_coauth)
V(g_coauth)$cluster <- membership(communities)
```

### Filtrado de red (para visualización):

```r
# Mantener solo autores con >= 2 publicaciones
authors_count <- authors_list %>% count(author)
top_authors <- authors_count %>% filter(n >= 2) %>% pull(author)

g_coauth_filtered <- induced_subgraph(
  g_coauth,
  vids = V(g_coauth)[name %in% top_authors]
)

# O mantener componente gigante
components <- components(g_coauth)
g_coauth_main <- induced_subgraph(
  g_coauth,
  vids = which(components$membership == which.max(components$csize))
)
```

### Visualización de red:

```r
library(ggraph)

ggraph(g_coauth_filtered, layout = "fr") +  # Fruchterman-Reingold
  geom_edge_link(aes(width = weight), alpha = 0.3, color = "gray70") +
  geom_node_point(aes(size = degree, color = factor(cluster)), alpha = 0.7) +
  geom_node_text(aes(label = name), size = 3, repel = TRUE) +
  scale_edge_width_continuous(range = c(0.5, 2)) +
  scale_size_continuous(range = c(2, 10)) +
  scale_color_manual(values = palette_network) +
  theme_graph() +
  labs(title = "Co-authorship Network")
```

---

## 7. MANEJO DE ERRORES Y VALIDACIONES

### Validaciones críticas en cada fase:

```r
# Validar que abstracts no están vacíos
stopifnot(sum(is.na(df$abstract)) == 0)
stopifnot(all(nchar(df$abstract) > 50))

# Validar que LDA convergió
stopifnot(!is.null(lda_model))
stopifnot(length(unique(df$topic_lda_id)) == optimal_k)

# Validar que red tiene componente conectado
stopifnot(components(g_coauth)$no >= 1)

# Validar distribución de citaciones
stopifnot(all(df$citations >= 0, na.rm = TRUE))
```

### Logging de progreso:

```r
# Al inicio de cada fase
cat("\n", "="*80, "\n")
cat("FASE 2A: ANÁLISIS TEMÁTICO\n")
cat("="*80, "\n")
cat("Inicio:", format(Sys.time(), "%Y-%m-%d %H:%M:%S"), "\n\n")

# Durante procesamiento
cat("✓ Preprocesamiento completado:", format(Sys.time(), "%H:%M:%S"), "\n")

# Al finalizar
cat("\n✅ FASE 2A COMPLETADA EXITOSAMENTE\n")
cat("Archivos generados:", list.files("outputs/figuras/tematicas"), "\n")
```

---

## 8. OPTIMIZACIÓN DE PERFORMANCE

### Para datasets grandes (>500 docs):

```r
# Usar parallel processing
library(parallel)
n_cores <- detectCores() - 1

# LDA con paralelización
control_LDA_Gibbs$nstart <- n_cores

# DTM sparse para ahorrar RAM
dtm_sparse <- as.DocumentTermMatrix(
  dtm_filtered,
  weighting = weightTf
)
```

### Gestión de memoria:

```r
# Limpiar objetos grandes después de uso
rm(corpus, corpus_clean)
gc()

# Guardar checkpoints
saveRDS(dtm_filtered, "outputs/data/processed/dtm_checkpoint.rds")
```

---

## 9. REPRODUCIBILIDAD

### Seeds fijos:

```r
# Al inicio de cada script
set.seed(12345)

# Para LDA
control_LDA_Gibbs$seed <- 12345

# Para redes (layouts)
set.seed(12345)
layout_fr <- layout_with_fr(g_coauth)
```

### Session info:

```r
# Al final de cada fase
writeLines(
  capture.output(sessionInfo()),
  "outputs/session_info_fase2a.txt"
)
```

---

## 10. CHECKLIST PRE-EJECUCIÓN

Antes de ejecutar cada fase, verificar:

**Fase 2A:**
- [ ] `datos_fusionados.csv` existe
- [ ] Campo `abstract` no tiene NAs
- [ ] Paquetes tm, topicmodels, ggalluvial instalados
- [ ] Directorio `outputs/figuras/tematicas/` existe

**Fase 2B:**
- [ ] Dataset con topic_lda_id disponible
- [ ] Campo `author` parseado correctamente
- [ ] Paquetes igraph, ggraph instalados
- [ ] Directorio `outputs/figuras/redes/` existe

**Fase 2C:**
- [ ] Campo `citations` existe (o extraer de metadata)
- [ ] Identificadores de autores únicos resueltos
- [ ] Paquetes bibliometrix, Hmisc instalados
- [ ] Directorio `outputs/figuras/impacto/` existe

---

## 11. OUTPUTS ESPERADOS POR FASE

### Fase 2A:
```
outputs/
├── data/processed/
│   ├── corpus_cleaned.rds
│   ├── dtm_filtered.rds
│   ├── lda_model.rds
│   └── datos_con_topics.csv
├── figuras/tematicas/
│   ├── 04_topics_heatmap.png
│   ├── 05_topics_evolution_sankey.html
│   ├── 06_wordclouds_grid.png
│   ├── 07_keywords_network.png
│   └── 08_trend_timeline.png
└── tablas/
    ├── 04_topics_descripcion.csv
    └── 05_keywords_tfidf.csv
```

### Fase 2B:
```
outputs/
├── data/processed/
│   ├── coautoria_network.rds
│   └── cocitacion_network.rds
├── figuras/redes/
│   ├── 09_coautoria_graph.png
│   ├── 10_coautoria_clusters.png
│   ├── 11_cocitacion_map.png
│   ├── 12_bibliographic_coupling.png
│   └── 13_journals_chord.png
└── tablas/
    ├── 06_autores_centrality.csv
    └── 07_journals_centrality.csv
```

### Fase 2C:
```
outputs/
├── figuras/impacto/
│   ├── 14_autores_productividad_impacto.png
│   ├── 15_distribucion_citaciones.png
│   └── 16_sleeping_beauties.png
└── tablas/
    ├── 08_autores_top50.csv
    ├── 09_highly_cited_papers.csv
    └── 10_sleeping_beauties.csv
```

---

**Última actualización:** Febrero 2026  
**Versión:** 1.0
