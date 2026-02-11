################################################################################
# ANÁLISIS BIBLIOMÉTRICO: DIDÁCTICA DE CIENCIAS NATURALES Y CALIDAD EDUCATIVA
# Fase 2A: Análisis Temático con NLP - VERSIÓN CORREGIDA
# Fecha: Febrero 2026
################################################################################
#
# OBJETIVOS DE ESTA FASE:
# 1. Preprocesar abstracts (limpieza, tokenización, stemming)
# 2. Extraer keywords mediante TF-IDF (solucionar problema de 60% sin keywords)
# 3. Perform topic modeling with LDA (optimal k between 6-10)
# 4. Generar 7 visualizaciones temáticas innovadoras
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

# Lista de paquetes necesarios
paquetes_fase2a <- c(
  "tm", "SnowballC", "topicmodels", "ldatuning", "stringr",
  "tidyverse", "wordcloud", "ggalluvial", "viridis", "scales",
  "patchwork", "ggrepel", "igraph", "ggraph", "tidygraph",
  "openxlsx", "RColorBrewer"
)

# Función para instalar paquetes faltantes
instalar_si_falta <- function(paquete) {
  if (!require(paquete, character.only = TRUE, quietly = TRUE)) {
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
# 2. CARGA Y PREPARACIÓN DE DATOS
# ==============================================================================

cat("Cargando datos fusionados...\n")

# Cargar datos
if (!file.exists("outputs/datos_fusionados.csv")) {
  stop("ERROR: No se encuentra 'outputs/datos_fusionados.csv'")
}

M <- read.csv("outputs/datos_fusionados.csv", stringsAsFactors = FALSE)
cat("Datos cargados:", nrow(M), "documentos\n")

# MAPEO DE CAMPOS BIBLIOMETRIX
# AB = Abstract
# PY = Publication Year
# DE = Author Keywords
# TI = Title
# SR = Short Reference (ID)

# Verificar campos críticos
if (!"AB" %in% names(M)) {
  stop("ERROR: El campo 'AB' (abstract) no existe en el dataset")
}

# Filtrar documentos con abstract válido
df_trabajo <- M %>%
  filter(!is.na(AB) & nchar(AB) > 50) %>%
  mutate(
    ID = SR,  # Short reference como ID
    abstract = AB,
    year_clean = as.numeric(PY),
    author_keywords = DE,
    title = TI
  )

cat("   - Documentos con abstract válido:", nrow(df_trabajo), "\n")
cat("   - Documentos sin abstract:", nrow(M) - nrow(df_trabajo), "\n\n")

# ==============================================================================
# 3. PREPROCESAMIENTO DE TEXTO (NLP)
# ==============================================================================

cat("STEP 1: Preprocessing abstracts...\n")

# Crear corpus desde abstracts
corpus <- Corpus(VectorSource(df_trabajo$abstract))
cat("   - Corpus created with", length(corpus), "documents\n")

# Custom stopwords
custom_stopwords <- c(
  # Palabras académicas comunes
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
  tm_map(content_transformer(tolower)) %>%
  tm_map(content_transformer(function(x) gsub("http\\S+|www\\S+", "", x))) %>%
  tm_map(removePunctuation) %>%
  tm_map(removeNumbers) %>%
  tm_map(removeWords, stopwords("english")) %>%
  tm_map(removeWords, custom_stopwords) %>%
  tm_map(stripWhitespace) %>%
  tm_map(stemDocument, language = "english")

cat("   - Limpieza completada\n")

# Crear Document-Term Matrix (DTM)
cat("   - Creando Document-Term Matrix...\n")
dtm <- DocumentTermMatrix(corpus_clean)
cat("     Dimensiones originales:", dim(dtm)[1], "docs x", dim(dtm)[2], "términos\n")

# Filtrar términos muy raros o muy comunes
dtm_filtered <- removeSparseTerms(dtm, sparse = 0.99)
cat("     Dimensiones filtradas:", dim(dtm_filtered)[1], "docs x",
    dim(dtm_filtered)[2], "términos\n")

# Remover documentos vacíos
row_sums <- rowSums(as.matrix(dtm_filtered))
dtm_filtered <- dtm_filtered[row_sums > 0, ]
df_trabajo <- df_trabajo[row_sums > 0, ]
cat("     Documentos finales:", nrow(df_trabajo), "\n")
cat("     Vocabulario final:", ncol(dtm_filtered), "términos\n\n")

# Guardar resultados intermedios
dir.create("data/processed", recursive = TRUE, showWarnings = FALSE)
saveRDS(corpus_clean, "data/processed/corpus_cleaned.rds")
saveRDS(dtm_filtered, "data/processed/dtm_filtered.rds")

cat("Preprocessing completed\n\n")

# ==============================================================================
# 4. EXTRACCIÓN DE KEYWORDS CON TF-IDF
# ==============================================================================

cat("STEP 2: Extracting keywords with TF-IDF...\n")

# Calcular TF-IDF
dtm_tfidf <- weightTfIdf(dtm_filtered)

# Extraer top 10 términos por documento
n_keywords <- 10
keywords_list <- list()

for (i in 1:nrow(dtm_tfidf)) {
  tfidf_scores <- as.matrix(dtm_tfidf)[i, ]
  top_indices <- order(tfidf_scores, decreasing = TRUE)[1:min(n_keywords, length(tfidf_scores))]
  top_terms <- colnames(dtm_tfidf)[top_indices]
  top_terms <- top_terms[!is.na(top_terms) & top_terms != ""]
  keywords_list[[i]] <- paste(top_terms, collapse = "; ")
}

# Añadir keywords al dataframe
df_trabajo$keywords_tfidf <- unlist(keywords_list)
df_trabajo$keywords_combined <- ifelse(
  !is.na(df_trabajo$author_keywords) & df_trabajo$author_keywords != "",
  paste(df_trabajo$author_keywords, df_trabajo$keywords_tfidf, sep = "; "),
  df_trabajo$keywords_tfidf
)

# Guardar tabla de cobertura
dir.create("outputs/tablas", recursive = TRUE, showWarnings = FALSE)
coverage_stats <- data.frame(
  Categoria = c("Keywords originales", "Keywords TF-IDF", "Keywords combinadas"),
  Documentos = c(
    sum(!is.na(df_trabajo$author_keywords) & df_trabajo$author_keywords != ""),
    nrow(df_trabajo),
    nrow(df_trabajo)
  ),
  Porcentaje = c(
    round(sum(!is.na(df_trabajo$author_keywords) &
                df_trabajo$author_keywords != "") / nrow(df_trabajo) * 100, 1),
    100, 100
  )
)
write.csv(coverage_stats, "outputs/tablas/05_keywords_coverage.csv", row.names = FALSE)

cat("Extracción de keywords completada\n")
cat("   - Cobertura:", coverage_stats$Porcentaje[1], "% →", coverage_stats$Porcentaje[3], "%\n\n")

# ==============================================================================
# 5. TOPIC MODELING CON LDA
# ==============================================================================

cat("STEP 3: Topic Modeling with LDA...\n")

# 5.1 Optimización del número de topics
cat("   Optimizando número de topics (esto toma varios minutos)...\n")

set.seed(12345)
k_range <- seq(6, 10, by = 1)

result_k <- FindTopicsNumber(
  dtm_filtered,
  topics = k_range,
  metrics = c("CaoJuan2009", "Arun2010", "Deveaud2014"),
  method = "Gibbs",
  control = list(seed = 12345, burnin = 500, iter = 1000, thin = 10),
  mc.cores = 1,
  verbose = FALSE
)

# Guardar gráfico de optimización
dir.create("outputs/figuras/tematicas", recursive = TRUE, showWarnings = FALSE)
png("outputs/figuras/tematicas/00_lda_optimization_metrics.png",
    width = 10, height = 6, units = "in", res = 300)
FindTopicsNumber_plot(result_k)
dev.off()

# Select optimal k (minimize CaoJuan and Arun)
optimal_k <- result_k$topics[which.min(result_k$CaoJuan2009)]
cat("   Optimal number of topics: k =", optimal_k, "\n\n")

# 5.2 Entrenar modelo LDA final
cat("   Entrenando modelo LDA final...\n")

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

saveRDS(lda_model, "data/processed/lda_model.rds")
cat("   Modelo LDA guardado\n\n")

# 5.3 Extraer topics y asignar a documentos
cat("   Extrayendo topics...\n")

topics_terms <- terms(lda_model, 20)
doc_topics <- topicmodels::posterior(lda_model)$topics

df_trabajo$topic_id <- apply(doc_topics, 1, which.max)
df_trabajo$topic_probability <- apply(doc_topics, 1, max)

# Añadir probabilidades de todos los topics
for (i in 1:optimal_k) {
  df_trabajo[[paste0("topic_", i, "_prob")]] <- doc_topics[, i]
}

# 5.4 Etiquetar topics
cat("\n   Top términos por topic:\n")
cat("   ", rep("-", 70), "\n")

for (i in 1:optimal_k) {
  cat("   Topic", i, ":", paste(topics_terms[1:10, i], collapse = ", "), "\n")
}
cat("   ", rep("-", 70), "\n\n")

# Etiquetas propuestas (ajustar según términos observados)
topic_labels <- c(
  "Technology-Enhanced Learning",
  "Inquiry-Based Science Education",
  "Assessment & Evaluation",
  "Teacher Professional Development",
  "STEM Integration",
  "Equity & Social Justice",
  "Environmental Education",
  "Conceptual Understanding",
  "Scientific Literacy",
  "Curriculum Design"
)[1:optimal_k]

df_trabajo$topic_label <- topic_labels[df_trabajo$topic_id]

# Guardar descripción de topics
topic_descriptions <- data.frame(
  Topic_ID = 1:optimal_k,
  Label = topic_labels,
  Top_10_Terms = apply(topics_terms[1:10, ], 2, paste, collapse = ", "),
  N_Documents = sapply(1:optimal_k, function(i) sum(df_trabajo$topic_id == i)),
  Pct_Corpus = round(sapply(1:optimal_k, function(i)
    sum(df_trabajo$topic_id == i) / nrow(df_trabajo) * 100), 1)
)
write.csv(topic_descriptions, "outputs/tablas/07_topics_descripcion.csv", row.names = FALSE)

cat("Topic Modeling completed\n")
cat("   - Topics identified:", optimal_k, "\n")
cat("   - Documents assigned:", nrow(df_trabajo), "\n\n")

# Guardar dataset enriquecido
write.csv(df_trabajo, "data/processed/datos_con_topics_y_keywords.csv", row.names = FALSE)
saveRDS(df_trabajo, "data/processed/datos_con_topics_y_keywords.rds")

# ==============================================================================
# 6. VISUALIZACIONES TEMÁTICAS
# ==============================================================================

cat("STEP 4: Generating thematic visualizations...\n\n")

# Configurar tema
theme_publication <- theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", size = 14, hjust = 0.5),
    plot.subtitle = element_text(size = 10, hjust = 0.5, color = "gray40"),
    axis.title = element_text(face = "bold", size = 11),
    legend.title = element_text(face = "bold"),
    panel.grid.minor = element_blank()
  )
theme_set(theme_publication)

# Paleta de colores
palette_topics <- viridis(optimal_k, option = "D")

# -------- VISUALIZATION 1: Topics Heatmap Temporal --------
cat("   Generating visualization 1/7: Topics Heatmap Temporal...\n")

topics_by_year <- df_trabajo %>%
  group_by(year_clean, topic_label) %>%
  summarise(n = n(), .groups = "drop") %>%
  group_by(year_clean) %>%
  mutate(pct = n / sum(n) * 100) %>%
  ungroup()

p1 <- ggplot(topics_by_year, aes(x = year_clean, y = topic_label, fill = pct)) +
  geom_tile(color = "white", size = 0.5) +
  scale_fill_viridis_c(option = "plasma", name = "% Documents") +
  scale_x_continuous(breaks = seq(2016, 2026, 1)) +
  labs(
    x = "Year", y = NULL
  )

ggsave("outputs/figuras/tematicas/01_topics_heatmap_temporal.png", p1,
       width = 12, height = 6, dpi = 300, bg = "white")

# -------- VISUALIZATION 2: Alluvial Diagram --------
cat("   Generating visualization 2/7: Alluvial Diagram...\n")

df_trabajo <- df_trabajo %>%
  mutate(
    periodo = case_when(
      year_clean >= 2016 & year_clean <= 2019 ~ "2016-2019\n(Pre-COVID)",
      year_clean >= 2020 & year_clean <= 2022 ~ "2020-2022\n(During COVID)",
      year_clean >= 2023 & year_clean <= 2026 ~ "2023-2026\n(Post-COVID)",
      TRUE ~ "Otro"
    )
  )

alluvial_data <- df_trabajo %>%
  filter(periodo != "Otro") %>%
  group_by(periodo, topic_label) %>%
  summarise(Freq = n(), .groups = "drop") %>%
  mutate(periodo = factor(periodo, levels = c(
    "2016-2019\n(Pre-COVID)",
    "2020-2022\n(Durante COVID)",
    "2023-2026\n(Post-COVID)"
  )))

# Calcular percentil 20 para identificar secciones pequeñas
threshold_freq <- quantile(alluvial_data$Freq, 0.20)

# Asignar color de texto basado en el tamaño de la sección
alluvial_data <- alluvial_data %>%
  mutate(text_color = ifelse(Freq <= threshold_freq, "black", "black"))

p2 <- ggplot(alluvial_data,
             aes(x = periodo, y = Freq,
                 stratum = topic_label, alluvium = topic_label,
                 fill = topic_label, label = topic_label)) +
  geom_alluvium(alpha = 0.7, width = 0.4) +
  geom_stratum(width = 0.4, color = "white") +
  geom_text(stat = "stratum", aes(color = text_color), size = 2.5) +
  scale_fill_manual(values = palette_topics) +
  scale_color_identity() +
  labs(
    x = NULL, y = "Number of Documents"
  ) +
  theme(legend.position = "none")

ggsave("outputs/figuras/tematicas/02_topics_alluvial_evolution.png", p2,
       width = 12, height = 8, dpi = 300, bg = "white")

# -------- VISUALIZATION 3: Word Clouds per Topic --------
cat("   Generating visualization 3/7: Word Clouds per Topic...\n")

png("outputs/figuras/tematicas/03_wordclouds_por_topic.png",
    width = 14, height = 10, units = "in", res = 300)

par(mfrow = c(ceiling(optimal_k/3), 3), mar = c(1, 1, 3, 1))

topic_word_probs <- topicmodels::posterior(lda_model)$terms

for (i in 1:optimal_k) {
  word_probs <- sort(topic_word_probs[i, ], decreasing = TRUE)[1:50]

  wordcloud(
    words = names(word_probs),
    freq = word_probs * 1000,
    max.words = 50,
    random.order = FALSE,
    colors = brewer.pal(8, "Dark2"),
    scale = c(3, 0.5)
  )

  title(main = paste("Topic", i, ":", topic_labels[i]),
        cex.main = 1.2, font.main = 2)
}

dev.off()

# -------- VISUALIZATION 4: Keywords Network --------
cat("   Generating visualization 4/7: Keywords Co-occurrence Network...\n")

keywords_split <- df_trabajo %>%
  select(ID, keywords_combined) %>%
  filter(!is.na(keywords_combined) & keywords_combined != "") %>%
  separate_rows(keywords_combined, sep = ";") %>%
  mutate(keyword = trimws(keywords_combined)) %>%
  filter(keyword != "" & !is.na(keyword))

keyword_freq <- keywords_split %>%
  count(keyword) %>%
  arrange(desc(n)) %>%
  filter(n >= 5)

# Seleccionar top 50 keywords primero
top_keywords <- keyword_freq %>% head(50)

# Crear co-ocurrencias SOLO entre keywords del top 50
keyword_cooc <- keywords_split %>%
  filter(keyword %in% top_keywords$keyword) %>%
  inner_join(keywords_split %>%
               filter(keyword %in% top_keywords$keyword),
             by = "ID", suffix = c("_1", "_2")) %>%
  filter(keyword_1 < keyword_2) %>%
  count(keyword_1, keyword_2, name = "weight") %>%
  filter(weight >= 3)

if (nrow(keyword_cooc) > 0) {
  g_keywords <- graph_from_data_frame(
    keyword_cooc,
    directed = FALSE,
    vertices = top_keywords
  )

  V(g_keywords)$degree <- degree(g_keywords)
  V(g_keywords)$size <- V(g_keywords)$n

  communities <- cluster_louvain(g_keywords)
  V(g_keywords)$cluster <- membership(communities)

  p4 <- ggraph(g_keywords, layout = "fr") +
    geom_edge_link(aes(width = weight), alpha = 0.3, color = "gray60") +
    geom_node_point(aes(size = size, color = factor(cluster)), alpha = 0.7) +
    geom_node_text(aes(label = name), size = 3, repel = TRUE, max.overlaps = 20) +
    scale_edge_width_continuous(range = c(0.5, 2), name = "Co-occurrence") +
    scale_size_continuous(range = c(3, 12), name = "Frequency") +
    scale_color_viridis_d(name = "Cluster") + theme_graph() +
    theme(
      plot.title = element_text(face = "bold", hjust = 0.5, size = 14),
      plot.subtitle = element_text(hjust = 0.5, size = 10, color = "gray40")
    )

  ggsave("outputs/figuras/tematicas/04_keywords_cooccurrence_network.png", p4,
         width = 14, height = 10, dpi = 300, bg = "white")
}

# -------- VISUALIZATION 5: Trend Timeline --------
cat("   Generating visualization 5/7: Trend Topics Timeline...\n")

topics_trend <- df_trabajo %>%
  filter(year_clean <= 2025) %>%
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
    x = "Year", y = "% of total per year"
  ) +
  theme(
    legend.position = "bottom",
    legend.text = element_text(size = 8),
    axis.text.x = element_text(angle = 45, hjust = 1)
  ) +
  guides(color = guide_legend(nrow = 2))

ggsave("outputs/figuras/tematicas/05_trend_topics_timeline.png", p5,
       width = 12, height = 8, dpi = 300, bg = "white")

# -------- VISUALIZATION 6: Geographic Distribution --------
cat("   Generating visualization 6/7: Geographic Distribution...\n")

# Extraer países del campo RP (Reprint Author Address)
if ("RP" %in% names(M) && any(!is.na(M$RP))) {
  # Extract countries from RP field (remove email addresses and extra text)
  M_paises <- M %>%
    filter(!is.na(RP) & RP != "") %>%
    mutate(
      pais = str_extract(RP, "[^,]+$"),
      pais = str_remove(pais, ";.*$"),  # Remove everything after semicolon (emails, etc.)
      pais = trimws(pais),
      pais = toupper(pais),
      # Standardize country names for publication
      pais = case_when(
        pais == "PEOPLES R CHINA" ~ "CHINA",
        pais == "TURKIYE" ~ "TURKEY",
        TRUE ~ pais
      )
    ) %>%
    filter(!is.na(pais) & pais != "")

  paises <- M_paises %>%
    count(pais, name = "Documents") %>%
    arrange(desc(Documents)) %>%
    head(15) %>%
    rename(Country = pais) %>%
    mutate(Percentage = round(Documents / nrow(M) * 100, 2))

  write.csv(paises, "outputs/tablas/11_top_paises.csv", row.names = FALSE)

  p6 <- ggplot(paises, aes(x = reorder(Country, Documents), y = Documents, fill = Documents)) +
    geom_col(show.legend = FALSE) +
    geom_text(aes(label = paste0(Documents, " (", Percentage, "%)")),
              hjust = -0.1, size = 3) +
    coord_flip() +
    scale_fill_viridis_c(option = "plasma") +
    ylim(0, max(paises$Documents) * 1.15) +
    labs(
      x = NULL, y = "Number of Documents"
    )

  ggsave("outputs/figuras/tematicas/06_distribucion_geografica.png", p6,
         width = 10, height = 7, dpi = 300, bg = "white")

  cat("   Geographic analysis completed\n")
} else {
  cat("   Country field not available, geographic analysis skipped\n")
}

# -------- VISUALIZATION 7: Distribution of Topics --------
cat("   Generating visualization 7/7: Distribution of Topics...\n")

topic_dist <- df_trabajo %>%
  count(topic_label) %>%
  mutate(pct = round(n / sum(n) * 100, 1)) %>%
  arrange(desc(n))

p7 <- ggplot(topic_dist, aes(x = reorder(topic_label, n), y = n, fill = topic_label)) +
  geom_col(show.legend = FALSE) +
  geom_text(aes(label = paste0(n, " (", pct, "%)")), hjust = -0.1, size = 3.5) +
  coord_flip() +
  scale_fill_manual(values = palette_topics) +
  ylim(0, max(topic_dist$n) * 1.15) +
  labs(
    x = NULL, y = "Number of Documents"
  )

ggsave("outputs/figuras/tematicas/07_distribucion_topics.png", p7,
       width = 10, height = 8, dpi = 300, bg = "white")

cat("\nVisualizations completed\n\n")

# ==============================================================================
# 7. MÉTRICAS DE VALIDACIÓN
# ==============================================================================

cat("STEP 5: Generating validation metrics...\n")

# Distribución de topics
topic_distribution <- df_trabajo %>%
  count(topic_label) %>%
  arrange(desc(n)) %>%
  mutate(
    Percentage = round(n / sum(n) * 100, 1),
    Cumulative_Percentage = cumsum(Percentage)
  ) %>%
  rename(Topic = topic_label, Documents = n)

write.csv(topic_distribution, "outputs/tablas/09_topics_distribucion.csv", row.names = FALSE)

# Topics por año
topics_by_year_table <- df_trabajo %>%
  count(year_clean, topic_label) %>%
  pivot_wider(names_from = topic_label, values_from = n, values_fill = 0) %>%
  arrange(year_clean)

write.csv(topics_by_year_table, "outputs/tablas/10_topics_por_anio.csv", row.names = FALSE)

cat("Validación completada\n\n")

# ==============================================================================
# 8. REPORTE FINAL
# ==============================================================================

cat("\n", rep("=", 80), "\n")
cat("FASE 2A COMPLETADA EXITOSAMENTE\n")
cat(rep("=", 80), "\n\n")

cat("RESUMEN DE RESULTADOS:\n")
cat("  Documentos procesados:", nrow(df_trabajo), "\n")
cat("  Vocabulario final:", ncol(dtm_filtered), "términos\n")
cat("  Keywords extraídas: 100% del corpus\n")
cat("  Topics identified:", optimal_k, "\n")
cat("  Visualizaciones generadas: 7\n")
cat("  Tablas generadas: 6\n\n")

cat("ARCHIVOS GENERADOS:\n")
cat("  data/processed/\n")
cat("     - datos_con_topics_y_keywords.csv\n")
cat("     - lda_model.rds\n")
cat("     - corpus_cleaned.rds\n")
cat("     - dtm_filtered.rds\n\n")
cat("  outputs/figuras/tematicas/\n")
cat("     - 7 visualizaciones PNG (300 DPI)\n\n")
cat("  outputs/tablas/\n")
cat("     - 6 tablas CSV\n\n")

cat("NEXT STEPS:\n")
cat("  1. Revisar visualizaciones en outputs/figuras/tematicas/\n")
cat("  2. Validar etiquetas de topics\n")
cat("  3. Ejecutar Fase 2B: Análisis de Redes\n\n")

cat("Fin:", format(Sys.time(), "%Y-%m-%d %H:%M:%S"), "\n")
cat(rep("=", 80), "\n\n")

# FIN DEL SCRIPT

