################################################################################
# ANÁLISIS BIBLIOMÉTRICO: DIDÁCTICA DE CIENCIAS NATURALES Y CALIDAD EDUCATIVA
# Fase 2A: Análisis Temático con NLP
# Fecha: Febrero 2026
################################################################################
#
# OBJETIVOS DE ESTA FASE:
# 1. Preprocesar abstracts (limpieza, tokenización, stemming)
# 2. Extraer keywords mediante TF-IDF (solucionar problema de 60% sin keywords)
# 3. Realizar topic modeling con LDA (k óptimo entre 6-10)
# 4. Generar 5 visualizaciones temáticas innovadoras
# 5. Crear tablas de resumen y validación
#
################################################################################

# ==============================================================================
# 1. INSTALACIÓN Y CARGA DE PAQUETES
# ==============================================================================

cat("\n", rep("=", 80), "\n")
cat("FASE 2A: ANÁLISIS TEMÁTICO Y EXTRACCIÓN DE KEYWORDS (NLP)\n")
cat(rep("=", 80), "\n")
cat("Inicio:", format(Sys.time(), "%Y-%m-%d %H:%M:%S"), "\n\n")

# Lista de paquetes necesarios para NLP y visualización
paquetes_fase2a <- c(
  # NLP Core
  "tm",              # Text mining framework
  "SnowballC",       # Stemming algorithms
  "quanteda",        # Quantitative text analysis
  "topicmodels",     # LDA implementation
  "ldatuning",       # Optimize number of topics
  "textclean",       # Text cleaning utilities
  "stringr",         # String manipulation

  # Visualización
  "tidyverse",       # ggplot2, dplyr, tidyr
  "wordcloud",       # Basic word clouds
  "ggwordcloud",     # ggplot2-style word clouds
  "ggalluvial",      # Sankey/alluvial diagrams
  "viridis",         # Colorblind-friendly palettes
  "scales",          # Scale formatting
  "patchwork",       # Combine multiple plots
  "ggrepel",         # Non-overlapping labels

  # Network analysis
  "igraph",          # Network graphs
  "ggraph",          # Network visualization
  "tidygraph",       # Tidy networks

  # Export
  "openxlsx",        # Excel export
  "htmlwidgets"      # Interactive plots
)

# Función para instalar paquetes faltantes
instalar_si_falta <- function(paquete) {
  if (!require(paquete, character.only = TRUE)) {
    cat("Instalando", paquete, "...\n")
    install.packages(paquete, dependencies = TRUE)
    library(paquete, character.only = TRUE)
  }
}

# Instalar y cargar todos los paquetes
cat("Verificando e instalando paquetes necesarios...\n")
suppressPackageStartupMessages({
  invisible(sapply(paquetes_fase2a, instalar_si_falta))
})
cat("Todos los paquetes cargados exitosamente\n\n")

# ==============================================================================
# 2. CONFIGURACIÓN Y CARGA DE DATOS
# ==============================================================================

cat("Cargando datos fusionados...\n")

# Verificar que el archivo existe
if (!file.exists("outputs/datos_fusionados.csv")) {
  stop("ERROR: No se encuentra 'outputs/datos_fusionados.csv'
       Por favor ejecuta primero el script 01_diagnostico_inicial_ACTUALIZADO.R")
}

# Cargar datos
df <- read.csv("outputs/datos_fusionados.csv", stringsAsFactors = FALSE)
cat("Datos cargados:", nrow(df), "documentos\n")

# Verificar campos críticos
if (!"abstract" %in% names(df)) {
  stop("ERROR: El campo 'abstract' no existe en el dataset")
}

# Filtrar documentos sin abstract
df_con_abstract <- df %>%
  filter(!is.na(abstract) & nchar(abstract) > 50)

cat("   - Documentos con abstract válido:", nrow(df_con_abstract), "\n")
cat("   - Documentos sin abstract:", nrow(df) - nrow(df_con_abstract), "\n\n")

# Usar solo los documentos con abstract para el análisis
df_trabajo <- df_con_abstract

# ==============================================================================
# 3. PREPROCESAMIENTO DE TEXTO
# ==============================================================================

cat("PASO 1: Preprocesamiento de abstracts...\n")

# Crear corpus desde abstracts
corpus <- Corpus(VectorSource(df_trabajo$abstract))
cat("   - Corpus creado con", length(corpus), "documentos\n")

# Stopwords personalizadas (además de las estándar)
custom_stopwords <- c(
  # Palabras comunes en papers académicos
  "study", "research", "paper", "article", "journal", "results", "findings",
  "analysis", "method", "methods", "approach", "data", "also", "using", "used",
  "based", "show", "showed", "however", "therefore", "thus", "may", "can",
  "will", "within", "between", "among", "across", "et", "al",

  # Palabras del dominio muy genéricas
  "education", "educational", "science", "scientific", "learning", "teaching",
  "student", "students", "teacher", "teachers", "school", "schools"
)

# Pipeline de limpieza
cat("   - Aplicando transformaciones de texto...\n")
corpus_clean <- corpus %>%
  tm_map(content_transformer(tolower)) %>%              # Minúsculas
  tm_map(content_transformer(function(x) {              # Remover URLs
    gsub("http\\S+|www\\S+", "", x)
  })) %>%
  tm_map(removePunctuation) %>%                         # Puntuación
  tm_map(removeNumbers) %>%                             # Números
  tm_map(removeWords, stopwords("english")) %>%         # Stopwords inglés
  tm_map(removeWords, stopwords("spanish")) %>%         # Stopwords español
  tm_map(removeWords, custom_stopwords) %>%             # Stopwords personalizadas
  tm_map(stripWhitespace) %>%                           # Espacios extra
  tm_map(stemDocument, language = "english")            # Stemming

cat("   - Limpieza completada\n")

# Crear Document-Term Matrix (DTM)
cat("   - Creando Document-Term Matrix...\n")
dtm <- DocumentTermMatrix(corpus_clean)
cat("     Dimensiones originales:", dim(dtm)[1], "docs x", dim(dtm)[2], "términos\n")

# Filtrar términos muy raros o muy comunes
# Remover términos que aparecen en <1% o >90% de documentos
dtm_filtered <- removeSparseTerms(dtm, sparse = 0.99)
cat("     Dimensiones filtradas:", dim(dtm_filtered)[1], "docs x",
    dim(dtm_filtered)[2], "términos\n")

# Remover documentos vacíos (sin términos después del filtrado)
row_sums <- rowSums(as.matrix(dtm_filtered))
dtm_filtered <- dtm_filtered[row_sums > 0, ]
df_trabajo <- df_trabajo[row_sums > 0, ]

cat("     Documentos finales:", dim(dtm_filtered)[1], "\n")
cat("     Vocabulario final:", dim(dtm_filtered)[2], "términos\n\n")

# Guardar resultados intermedios
saveRDS(corpus_clean, "data/processed/corpus_cleaned.rds")
saveRDS(dtm_filtered, "data/processed/dtm_filtered.rds")

# Estadísticas del preprocesamiento
doc_lengths <- rowSums(as.matrix(dtm_filtered))
vocab <- Terms(dtm_filtered)

stats_preprocesamiento <- data.frame(
  Metrica = c("Total documentos", "Total términos únicos",
              "Media términos/doc", "Mediana términos/doc",
              "Min términos/doc", "Max términos/doc"),
  Valor = c(nrow(dtm_filtered), ncol(dtm_filtered),
            round(mean(doc_lengths), 1), round(median(doc_lengths), 1),
            min(doc_lengths), max(doc_lengths))
)

write.csv(stats_preprocesamiento,
          "outputs/tablas/04_preprocesamiento_estadisticas.csv",
          row.names = FALSE)

cat("Preprocesamiento completado\n")
cat("   Archivos guardados:\n")
cat("   - data/processed/corpus_cleaned.rds\n")
cat("   - data/processed/dtm_filtered.rds\n")
cat("   - outputs/tablas/04_preprocesamiento_estadisticas.csv\n\n")

# ==============================================================================
# 4. EXTRACCIÓN DE KEYWORDS CON TF-IDF
# ==============================================================================

cat("PASO 2: Extracción de keywords con TF-IDF...\n")

# Calcular TF-IDF
dtm_tfidf <- weightTfIdf(dtm_filtered)

# Extraer top 10 términos por documento (basado en TF-IDF)
n_keywords <- 10
keywords_list <- list()

for (i in 1:nrow(dtm_tfidf)) {
  # Obtener scores TF-IDF para el documento
  tfidf_scores <- as.matrix(dtm_tfidf)[i, ]

  # Ordenar y tomar top N
  top_indices <- order(tfidf_scores, decreasing = TRUE)[1:n_keywords]
  top_terms <- colnames(dtm_tfidf)[top_indices]

  # Limpiar NA y términos vacíos
  top_terms <- top_terms[!is.na(top_terms) & top_terms != ""]

  keywords_list[[i]] <- paste(top_terms, collapse = "; ")
}

# Añadir keywords extraídas al dataframe
df_trabajo$keywords_tfidf <- unlist(keywords_list)

# Combinar con keywords originales (si existen)
df_trabajo <- df_trabajo %>%
  mutate(
    keywords_original = ifelse(is.na(author_keywords) | author_keywords == "",
                               NA, author_keywords),
    keywords_combined = case_when(
      !is.na(keywords_original) & keywords_original != "" ~
        paste(keywords_original, keywords_tfidf, sep = "; "),
      TRUE ~ keywords_tfidf
    )
  )

# Calcular cobertura de keywords
coverage_stats <- data.frame(
  Categoria = c("Keywords originales", "Keywords TF-IDF extraídas",
                "Keywords combinadas"),
  Documentos_con_keywords = c(
    sum(!is.na(df_trabajo$keywords_original) & df_trabajo$keywords_original != ""),
    nrow(df_trabajo),
    nrow(df_trabajo)
  ),
  Porcentaje = c(
    round(sum(!is.na(df_trabajo$keywords_original) &
                df_trabajo$keywords_original != "") / nrow(df_trabajo) * 100, 1),
    100,
    100
  )
)

write.csv(coverage_stats,
          "outputs/tablas/05_keywords_coverage.csv",
          row.names = FALSE)

# Ranking global de términos TF-IDF
term_importance <- colSums(as.matrix(dtm_tfidf))
top_terms_global <- data.frame(
  Termino = names(term_importance),
  Score_TFIDF = term_importance
) %>%
  arrange(desc(Score_TFIDF)) %>%
  head(50)

write.csv(top_terms_global,
          "outputs/tablas/06_top_keywords_tfidf.csv",
          row.names = FALSE)

cat("Extracción de keywords completada\n")
cat("   - Keywords extraídas para", nrow(df_trabajo), "documentos\n")
cat("   - Cobertura original:",
    coverage_stats$Porcentaje[1], "% →", coverage_stats$Porcentaje[3], "%\n")
cat("   Archivos guardados:\n")
cat("   - outputs/tablas/05_keywords_coverage.csv\n")
cat("   - outputs/tablas/06_top_keywords_tfidf.csv\n\n")

# ==============================================================================
# 5. TOPIC MODELING CON LDA
# ==============================================================================

cat("PASO 3: Topic Modeling con LDA...\n")

# 5.1 Optimización del número de topics
cat("   Fase 3.1: Optimizando número de topics (k)...\n")
cat("   (Esto puede tomar varios minutos, por favor espera...)\n")

# Probar rango de k de 5 a 12
k_range <- seq(5, 12, by = 1)

# NOTA: ldatuning puede ser lento. Para pruebas rápidas, comentar y usar k fijo
# Si quieres acelerar, comenta las siguientes líneas y descomenta "optimal_k <- 8"

set.seed(12345)  # Para reproducibilidad

result_k <- FindTopicsNumber(
  dtm_filtered,
  topics = k_range,
  metrics = c("CaoJuan2009", "Arun2010", "Deveaud2014"),
  method = "Gibbs",
  control = list(seed = 12345, burnin = 500, iter = 1000, thin = 10),
  mc.cores = 1,  # Ajustar según CPU disponibles
  verbose = TRUE
)

# Visualizar métricas
png("outputs/figuras/tematicas/00_lda_optimization_metrics.png",
    width = 10, height = 6, units = "in", res = 300)
FindTopicsNumber_plot(result_k)
dev.off()

# Seleccionar k óptimo (basado en métricas)
# REGLA: Minimizar CaoJuan2009 y Arun2010, Maximizar Deveaud2014
optimal_k <- result_k$topics[which.min(result_k$CaoJuan2009)]
cat("   ✓ Número óptimo de topics seleccionado: k =", optimal_k, "\n\n")

# Para acelerar pruebas, puedes descomentar esta línea y comentar el bloque anterior:
# optimal_k <- 8

# 5.2 Entrenar modelo LDA final
cat("   Fase 3.2: Entrenando modelo LDA con k =", optimal_k, "...\n")

control_LDA <- list(
  seed = 12345,
  burnin = 1000,
  iter = 2000,
  thin = 10,
  alpha = 0.1,
  delta = 0.01
)

set.seed(12345)
lda_model <- LDA(
  dtm_filtered,
  k = optimal_k,
  method = "Gibbs",
  control = control_LDA
)

# Guardar modelo
saveRDS(lda_model, "data/processed/lda_model.rds")
cat("   ✓ Modelo LDA entrenado y guardado\n")

# 5.3 Extraer topics
cat("   Fase 3.3: Extrayendo topics y asignaciones...\n")

# Top términos por topic
topics_terms <- terms(lda_model, 20)

# Probabilidades de topics por documento
doc_topics <- posterior(lda_model)$topics

# Asignar topic dominante
df_trabajo$topic_id <- apply(doc_topics, 1, which.max)
df_trabajo$topic_probability <- apply(doc_topics, 1, max)

# Añadir todas las probabilidades para análisis posterior
for (i in 1:optimal_k) {
  df_trabajo[[paste0("topic_", i, "_prob")]] <- doc_topics[, i]
}

# 5.4 Etiquetar topics manualmente
cat("   Fase 3.4: Generando etiquetas de topics...\n\n")
cat("   Top términos por topic:\n")
cat("   ", rep("-", 70), "\n")

# Mostrar términos para ayudar al etiquetado
for (i in 1:optimal_k) {
  cat("   Topic", i, ":", paste(topics_terms[1:10, i], collapse = ", "), "\n")
}

cat("   ", rep("-", 70), "\n\n")

# ETIQUETAS PROPUESTAS (revisar y ajustar según términos observados)
# Estas son hipótesis que debes validar mirando los términos arriba
topic_labels <- c(
  "Technology-Enhanced Learning",
  "Inquiry-Based Science Education",
  "Assessment & Evaluation",
  "Teacher Professional Development",
  "STEM Integration",
  "Equity & Social Justice",
  "Environmental Education",
  "Conceptual Understanding"
)[1:optimal_k]  # Tomar solo las necesarias

df_trabajo$topic_label <- topic_labels[df_trabajo$topic_id]

# Tabla de descripción de topics
topic_descriptions <- data.frame(
  Topic_ID = 1:optimal_k,
  Label = topic_labels,
  Top_10_Terms = apply(topics_terms[1:10, ], 2, paste, collapse = ", "),
  N_Documents = sapply(1:optimal_k, function(i) sum(df_trabajo$topic_id == i)),
  Pct_Corpus = round(sapply(1:optimal_k, function(i)
    sum(df_trabajo$topic_id == i) / nrow(df_trabajo) * 100), 1)
)

write.csv(topic_descriptions,
          "outputs/tablas/07_topics_descripcion.csv",
          row.names = FALSE)

cat("Topic Modeling completado\n")
cat("   - Número de topics:", optimal_k, "\n")
cat("   - Documentos asignados:", nrow(df_trabajo), "\n")
cat("   Archivos guardados:\n")
cat("   - data/processed/lda_model.rds\n")
cat("   - outputs/tablas/07_topics_descripcion.csv\n\n")

# ==============================================================================
# 6. GUARDAR DATASET ENRIQUECIDO
# ==============================================================================

cat("💾 Guardando dataset enriquecido con topics y keywords...\n")

# Guardar CSV
write.csv(df_trabajo,
          "data/processed/datos_con_topics_y_keywords.csv",
          row.names = FALSE)

# Guardar RDS (más rápido para cargar en R)
saveRDS(df_trabajo,
        "data/processed/datos_con_topics_y_keywords.rds")

cat("Dataset guardado con", ncol(df_trabajo), "columnas\n")
cat("   - data/processed/datos_con_topics_y_keywords.csv\n")
cat("   - data/processed/datos_con_topics_y_keywords.rds\n\n")

# ==============================================================================
# 7. VISUALIZACIONES TEMÁTICAS
# ==============================================================================

cat("PASO 4: Generando visualizaciones temáticas...\n\n")

# Configurar tema ggplot2 para todas las visualizaciones
theme_publication <- theme_minimal() +
  theme(
    text = element_text(family = "sans", size = 10),
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

theme_set(theme_publication)

# Paleta de colores consistente
palette_topics <- viridis(optimal_k, option = "D")

# -------- VISUALIZACIÓN 1: Topics Heatmap Temporal --------
cat("   Generando visualización 1/5: Topics Heatmap Temporal...\n")

# Preparar datos
topics_by_year <- df_trabajo %>%
  group_by(year_clean, topic_label) %>%
  summarise(n = n(), .groups = "drop") %>%
  group_by(year_clean) %>%
  mutate(pct = n / sum(n) * 100) %>%
  ungroup()

# Crear heatmap
p1 <- ggplot(topics_by_year, aes(x = year_clean, y = topic_label, fill = pct)) +
  geom_tile(color = "white", size = 0.5) +
  scale_fill_viridis_c(option = "plasma", name = "% Documentos") +
  scale_x_continuous(breaks = seq(2016, 2026, 1)) +
  labs(
    title = "Evolución Temporal de Topics (2016-2026)",
    subtitle = paste("Análisis de", nrow(df_trabajo), "documentos |",
                     optimal_k, "topics identificados"),
    x = "Año",
    y = NULL
  ) +
  theme(
    axis.text.x = element_text(angle = 0, hjust = 0.5),
    legend.position = "right"
  )

ggsave("outputs/figuras/tematicas/01_topics_heatmap_temporal.png", p1,
       width = 12, height = 6, dpi = 300, bg = "white")

# -------- VISUALIZACIÓN 2: Alluvial Diagram (Evolución de Topics) --------
cat("   Generando visualización 2/5: Alluvial Diagram...\n")

# Crear periodos para el alluvial
df_trabajo <- df_trabajo %>%
  mutate(
    periodo = case_when(
      year_clean >= 2016 & year_clean <= 2019 ~ "2016-2019\n(Pre-COVID)",
      year_clean >= 2020 & year_clean <= 2022 ~ "2020-2022\n(Durante COVID)",
      year_clean >= 2023 & year_clean <= 2026 ~ "2023-2026\n(Post-COVID)",
      TRUE ~ "Otro"
    )
  )

# Preparar datos para alluvial
alluvial_data <- df_trabajo %>%
  filter(periodo != "Otro") %>%
  group_by(periodo, topic_label) %>%
  summarise(Freq = n(), .groups = "drop") %>%
  mutate(periodo = factor(periodo,
                         levels = c("2016-2019\n(Pre-COVID)",
                                   "2020-2022\n(Durante COVID)",
                                   "2023-2026\n(Post-COVID)")))

p2 <- ggplot(alluvial_data,
             aes(x = periodo, y = Freq, alluvium = topic_label)) +
  geom_alluvium(aes(fill = topic_label), alpha = 0.7, width = 0.4) +
  geom_stratum(aes(fill = topic_label), width = 0.4, color = "white") +
  geom_text(stat = "stratum", aes(label = topic_label), size = 3) +
  scale_fill_manual(values = palette_topics) +
  labs(
    title = "Evolución de Topics a través de Periodos",
    subtitle = "Cambios temáticos: Pre-COVID → Durante COVID → Post-COVID",
    x = NULL,
    y = "Número de Documentos"
  ) +
  theme(legend.position = "none")

ggsave("outputs/figuras/tematicas/02_topics_alluvial_evolution.png", p2,
       width = 12, height = 8, dpi = 300, bg = "white")

# -------- VISUALIZACIÓN 3: Word Clouds por Topic --------
cat("   Generando visualización 3/5: Word Clouds por Topic...\n")

# Crear grid de word clouds
png("outputs/figuras/tematicas/03_wordclouds_por_topic.png",
    width = 14, height = 10, units = "in", res = 300)

# Configurar layout en grid
par(mfrow = c(ceiling(optimal_k/3), 3), mar = c(1, 1, 3, 1))

# Extraer términos y probabilidades del modelo LDA
topic_word_probs <- posterior(lda_model)$terms

for (i in 1:optimal_k) {
  # Obtener términos del topic
  word_probs <- sort(topic_word_probs[i, ], decreasing = TRUE)[1:50]

  # Generar word cloud
  wordcloud(
    words = names(word_probs),
    freq = word_probs * 1000,  # Escalar para visualización
    max.words = 50,
    random.order = FALSE,
    colors = brewer.pal(8, "Dark2"),
    scale = c(3, 0.5)
  )

  title(main = paste("Topic", i, ":", topic_labels[i]),
        cex.main = 1.2, font.main = 2)
}

dev.off()

# -------- VISUALIZACIÓN 4: Keywords Co-occurrence Network --------
cat("   Generando visualización 4/5: Keywords Co-occurrence Network...\n")

# Extraer keywords individuales
keywords_split <- df_trabajo %>%
  select(ID, keywords_combined) %>%
  filter(!is.na(keywords_combined) & keywords_combined != "") %>%
  separate_rows(keywords_combined, sep = ";") %>%
  mutate(keyword = trimws(keywords_combined)) %>%
  filter(keyword != "" & !is.na(keyword))

# Contar frecuencia de keywords
keyword_freq <- keywords_split %>%
  count(keyword) %>%
  arrange(desc(n)) %>%
  filter(n >= 5)  # Mantener keywords que aparecen al menos 5 veces

# Crear matriz de co-ocurrencia
# Keywords que aparecen en el mismo documento
keyword_cooc <- keywords_split %>%
  filter(keyword %in% keyword_freq$keyword) %>%
  inner_join(keywords_split %>%
               filter(keyword %in% keyword_freq$keyword),
             by = "ID", suffix = c("_1", "_2")) %>%
  filter(keyword_1 < keyword_2) %>%
  count(keyword_1, keyword_2, name = "weight") %>%
  filter(weight >= 3)  # Mantener co-ocurrencias de al menos 3 veces

# Crear red
if (nrow(keyword_cooc) > 0) {
  g_keywords <- graph_from_data_frame(
    keyword_cooc,
    directed = FALSE,
    vertices = keyword_freq %>% head(50)  # Top 50 keywords
  )

  # Calcular métricas
  V(g_keywords)$degree <- degree(g_keywords)
  V(g_keywords)$size <- V(g_keywords)$n  # Frecuencia

  # Detectar comunidades
  communities <- cluster_louvain(g_keywords)
  V(g_keywords)$cluster <- membership(communities)

  # Visualizar con ggraph
  p4 <- ggraph(g_keywords, layout = "fr") +
    geom_edge_link(aes(width = weight), alpha = 0.3, color = "gray60") +
    geom_node_point(aes(size = size, color = factor(cluster)), alpha = 0.7) +
    geom_node_text(aes(label = name), size = 3, repel = TRUE, max.overlaps = 20) +
    scale_edge_width_continuous(range = c(0.5, 2), name = "Co-ocurrencia") +
    scale_size_continuous(range = c(3, 12), name = "Frecuencia") +
    scale_color_viridis_d(name = "Cluster") +
    labs(
      title = "Red de Co-ocurrencia de Keywords",
      subtitle = paste("Top 50 keywords más frecuentes |",
                      length(unique(V(g_keywords)$cluster)), "clusters detectados")
    ) +
    theme_graph() +
    theme(
      plot.title = element_text(face = "bold", hjust = 0.5, size = 14),
      plot.subtitle = element_text(hjust = 0.5, size = 10, color = "gray40")
    )

  ggsave("outputs/figuras/tematicas/04_keywords_cooccurrence_network.png", p4,
         width = 14, height = 10, dpi = 300, bg = "white")
} else {
  cat("   No hay suficientes co-ocurrencias para generar red\n")
}

# -------- VISUALIZACIÓN 5: Trend Topics Timeline --------
cat("   Generando visualización 5/5: Trend Topics Timeline...\n")

# Calcular proporción de cada topic por año
topics_trend <- df_trabajo %>%
  filter(year_clean <= 2025) %>%  # Excluir 2026 (datos parciales)
  group_by(year_clean, topic_label) %>%
  summarise(n = n(), .groups = "drop") %>%
  group_by(year_clean) %>%
  mutate(pct = n / sum(n) * 100) %>%
  ungroup()

p5 <- ggplot(topics_trend, aes(x = year_clean, y = pct, color = topic_label)) +
  geom_line(size = 1.2, alpha = 0.8) +
  geom_point(size = 2.5) +
  scale_color_manual(values = palette_topics, name = "Topic") +
  scale_x_continuous(breaks = seq(2016, 2025, 1)) +
  scale_y_continuous(labels = function(x) paste0(x, "%")) +
  labs(
    title = "Tendencias Temporales de Topics (2016-2025)",
    subtitle = "Proporción relativa de cada topic por año",
    x = "Año",
    y = "% del total de documentos por año"
  ) +
  theme(
    legend.position = "bottom",
    legend.text = element_text(size = 8),
    axis.text.x = element_text(angle = 45, hjust = 1)
  ) +
  guides(color = guide_legend(nrow = 2))

ggsave("outputs/figuras/tematicas/05_trend_topics_timeline.png", p5,
       width = 12, height = 8, dpi = 300, bg = "white")

cat("\nVisualizaciones completadas\n")
cat("   Archivos generados en outputs/figuras/tematicas/:\n")
cat("   - 00_lda_optimization_metrics.png\n")
cat("   - 01_topics_heatmap_temporal.png\n")
cat("   - 02_topics_alluvial_evolution.png\n")
cat("   - 03_wordclouds_por_topic.png\n")
cat("   - 04_keywords_cooccurrence_network.png\n")
cat("   - 05_trend_topics_timeline.png\n\n")

# ==============================================================================
# 8. VALIDACIÓN Y MÉTRICAS FINALES
# ==============================================================================

cat("✔️  PASO 5: Generando métricas de validación...\n")

# Coherence del modelo (métrica de calidad)
# Nota: Esto requiere el paquete textmineR, si no está disponible se omite
if (require("textmineR", quietly = TRUE)) {
  phi <- posterior(lda_model)$terms
  coherence_scores <- CalcProbCoherence(phi = phi, dtm = dtm_filtered)

  coherence_df <- data.frame(
    Topic_ID = 1:optimal_k,
    Topic_Label = topic_labels,
    Coherence_Score = coherence_scores
  )

  write.csv(coherence_df,
            "outputs/tablas/08_topics_coherence_scores.csv",
            row.names = FALSE)

  cat("   - Coherence promedio:", round(mean(coherence_scores), 3), "\n")
  cat("     (>0.4 aceptable, >0.6 bueno)\n")
} else {
  cat("   Paquete textmineR no disponible, coherence no calculado\n")
}

# Resumen de distribución de topics
topic_distribution <- df_trabajo %>%
  count(topic_label) %>%
  arrange(desc(n)) %>%
  mutate(
    Porcentaje = round(n / sum(n) * 100, 1),
    Porcentaje_Acumulado = cumsum(Porcentaje)
  ) %>%
  rename(Topic = topic_label, Documentos = n)

write.csv(topic_distribution,
          "outputs/tablas/09_topics_distribucion.csv",
          row.names = FALSE)

# Tabla de topics por año
topics_by_year_table <- df_trabajo %>%
  count(year_clean, topic_label) %>%
  pivot_wider(names_from = topic_label, values_from = n, values_fill = 0) %>%
  arrange(year_clean)

write.csv(topics_by_year_table,
          "outputs/tablas/10_topics_por_año.csv",
          row.names = FALSE)

cat("Validación completada\n")
cat("   Tablas generadas:\n")
cat("   - outputs/tablas/08_topics_coherence_scores.csv\n")
cat("   - outputs/tablas/09_topics_distribucion.csv\n")
cat("   - outputs/tablas/10_topics_por_año.csv\n\n")

# ==============================================================================
# 9. REPORTE FINAL
# ==============================================================================

cat("\n", rep("=", 80), "\n")
cat("FASE 2A COMPLETADA EXITOSAMENTE\n")
cat(rep("=", 80), "\n\n")

cat("RESUMEN DE RESULTADOS:\n")
cat("  Documentos procesados:", nrow(df_trabajo), "\n")
cat("  Vocabulario final:", ncol(dtm_filtered), "términos\n")
cat("  Keywords extraídas: 100% del corpus (vs 40% original)\n")
cat("  Topics identificados:", optimal_k, "\n")
cat("  Visualizaciones generadas: 6\n")
cat("  Tablas generadas: 7\n\n")

cat("ARCHIVOS PRINCIPALES GENERADOS:\n")
cat("  data/processed/\n")
cat("     - datos_con_topics_y_keywords.csv (dataset enriquecido)\n")
cat("     - lda_model.rds (modelo LDA)\n")
cat("     - corpus_cleaned.rds\n")
cat("     - dtm_filtered.rds\n\n")
cat("     outputs/figuras/tematicas/\n")
cat("     - 6 visualizaciones PNG (300 DPI)\n\n")
cat("     outputs/tablas/\n")
cat("     - 7 tablas CSV con estadísticas\n\n")

cat("PRÓXIMOS PASOS:\n")
cat("  1. Revisar visualizaciones en outputs/figuras/tematicas/\n")
cat("  2. Validar etiquetas de topics en tabla 07_topics_descripcion.csv\n")
cat("  3. Ajustar etiquetas manualmente si es necesario\n")
cat("  4. Ejecutar Fase 2B: Análisis de Redes\n\n")

cat("Fin:", format(Sys.time(), "%Y-%m-%d %H:%M:%S"), "\n")
cat(rep("=", 80), "\n\n")

# ==============================================================================
# FIN DEL SCRIPT
# ==============================================================================
