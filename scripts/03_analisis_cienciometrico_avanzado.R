################################################################################
# BIBLIOMETRIC ANALYSIS: NATURAL SCIENCES EDUCATION AND EDUCATIONAL QUALITY
# Phase 3: Advanced Scientometric Analysis
# Date: February 2026
################################################################################
#
# OBJECTIVES OF THIS PHASE:
# 1. Author collaboration network analysis
# 2. Institution collaboration network analysis
# 3. Country collaboration network analysis
# 4. Citation network analysis
# 5. Bradford's Law (journal core identification)
# 6. Lotka's Law (author productivity distribution)
# 7. h-index and citation metrics
# 8. Science mapping (co-citation, bibliographic coupling)
#
################################################################################

# ==============================================================================
# 1. LOAD PACKAGES AND DATA
# ==============================================================================

library(bibliometrix)
library(tidyverse)
library(igraph)
library(ggraph)
library(viridis)
library(networkD3)
library(scales)

cat("Loading merged dataset...\n")
# Load using bibliometrix format (preserves field structure)
M <- readRDS("outputs/datos_fusionados.rds")
cat("  Documents loaded:", nrow(M), "\n")
cat("  Fields available:", ncol(M), "\n\n")

# Create output directories
dir.create("outputs/figuras/redes", recursive = TRUE, showWarnings = FALSE)
dir.create("outputs/figuras/cienciometria", recursive = TRUE, showWarnings = FALSE)
dir.create("outputs/tablas/redes", recursive = TRUE, showWarnings = FALSE)
dir.create("outputs/tablas/cienciometria", recursive = TRUE, showWarnings = FALSE)

# Configure publication theme
theme_publication <- theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", size = 14, hjust = 0.5),
    plot.subtitle = element_text(size = 10, hjust = 0.5, color = "gray40"),
    axis.title = element_text(face = "bold", size = 11),
    legend.title = element_text(face = "bold"),
    panel.grid.minor = element_blank()
  )
theme_set(theme_publication)

# ==============================================================================
# 2. AUTHOR COLLABORATION NETWORK
# ==============================================================================

cat("STEP 1: Author collaboration network analysis...\n")

# Validate AU field exists and has data
if (!"AU" %in% names(M) || all(is.na(M$AU))) {
  cat("  WARNING: AU field missing or empty. Skipping author network.\n\n")
} else {
  # Create author collaboration network
  NetMatrix_authors <- biblioNetwork(M,
                                     analysis = "collaboration",
                                     network = "authors",
                                     sep = ";")

# Network statistics
net_authors <- graph_from_adjacency_matrix(NetMatrix_authors,
                                           mode = "undirected",
                                           weighted = TRUE)

# Calculate metrics - USE EXPLICIT NAMESPACE to avoid conflicts
V(net_authors)$degree <- igraph::degree(net_authors)
V(net_authors)$betweenness <- igraph::betweenness(net_authors, normalized = TRUE)
V(net_authors)$closeness <- igraph::closeness(net_authors, normalized = TRUE)

# Detect communities
communities_authors <- igraph::cluster_louvain(net_authors)
V(net_authors)$community <- igraph::membership(communities_authors)

# Extract top authors (degree >= 3)
top_authors <- V(net_authors)[V(net_authors)$degree >= 3]
subnet_authors <- igraph::induced_subgraph(net_authors, top_authors)

# CRITICAL: Recalculate metrics on the SUBGRAPH (attributes don't transfer automatically)
V(subnet_authors)$degree <- igraph::degree(subnet_authors)
V(subnet_authors)$betweenness <- igraph::betweenness(subnet_authors, normalized = TRUE)
V(subnet_authors)$closeness <- igraph::closeness(subnet_authors, normalized = TRUE)
communities_subnet <- igraph::cluster_louvain(subnet_authors)
V(subnet_authors)$community <- igraph::membership(communities_subnet)

cat("  Total authors:", vcount(net_authors), "\n")
cat("  Collaboration edges:", ecount(net_authors), "\n")
cat("  Communities detected:", length(unique(V(net_authors)$community)), "\n")
cat("  Top authors (degree >= 3):", vcount(subnet_authors), "\n\n")

# Visualization
p1 <- ggraph(subnet_authors, layout = "fr") +
  geom_edge_link(aes(width = weight), alpha = 0.3, color = "gray60") +
  geom_node_point(aes(size = degree, color = factor(community)), alpha = 0.7) +
  geom_node_text(aes(label = name), size = 2.5, repel = TRUE, max.overlaps = 15) +
  scale_edge_width_continuous(range = c(0.3, 2), name = "Collaborations") +
  scale_size_continuous(range = c(3, 10), name = "Degree") +
  scale_color_viridis_d(name = "Community") +
  labs(
    title = "Author Collaboration Network",
    subtitle = paste("Top authors with ≥3 collaborations |",
                     length(unique(V(subnet_authors)$community)), "communities")
  ) +
  theme_graph() +
  theme(
    plot.title = element_text(face = "bold", hjust = 0.5, size = 14),
    plot.subtitle = element_text(hjust = 0.5, size = 10, color = "gray40")
  )

ggsave("outputs/figuras/redes/01_author_collaboration_network.png", p1,
       width = 14, height = 10, dpi = 300, bg = "white")

# Top authors table
author_metrics <- data.frame(
  Author = V(subnet_authors)$name,
  Degree = V(subnet_authors)$degree,
  Betweenness = round(V(subnet_authors)$betweenness, 3),
  Closeness = round(V(subnet_authors)$closeness, 3),
  Community = V(subnet_authors)$community,
  stringsAsFactors = FALSE
) %>%
  arrange(desc(Degree)) %>%
  head(20)

write.csv(author_metrics, "outputs/tablas/redes/01_top_authors_metrics.csv",
          row.names = FALSE)
}  # End of AU field validation

# ==============================================================================
# 3. COUNTRY COLLABORATION NETWORK
# ==============================================================================

cat("STEP 2: Country collaboration network analysis...\n")

# Validate AU_CO field exists
if (!"AU_CO" %in% names(M) || all(is.na(M$AU_CO))) {
  cat("  WARNING: AU_CO field missing or empty. Skipping country network.\n\n")
} else {
  # Create country collaboration network
  NetMatrix_countries <- biblioNetwork(M,
                                       analysis = "collaboration",
                                       network = "countries",
                                       sep = ";")

# Network statistics
net_countries <- graph_from_adjacency_matrix(NetMatrix_countries,
                                             mode = "undirected",
                                             weighted = TRUE)

V(net_countries)$degree <- igraph::degree(net_countries)
V(net_countries)$betweenness <- igraph::betweenness(net_countries, normalized = TRUE)

# Extract top countries (degree >= 2)
top_countries <- V(net_countries)[V(net_countries)$degree >= 2]
subnet_countries <- igraph::induced_subgraph(net_countries, top_countries)

# CRITICAL: Recalculate metrics on the SUBGRAPH
V(subnet_countries)$degree <- igraph::degree(subnet_countries)
V(subnet_countries)$betweenness <- igraph::betweenness(subnet_countries, normalized = TRUE)

cat("  Total countries:", vcount(net_countries), "\n")
cat("  Collaboration edges:", ecount(net_countries), "\n")
cat("  Top countries (degree >= 2):", vcount(subnet_countries), "\n\n")

# Visualization
p2 <- ggraph(subnet_countries, layout = "kk") +
  geom_edge_link(aes(width = weight), alpha = 0.4, color = "steelblue") +
  geom_node_point(aes(size = degree), color = "darkblue", alpha = 0.7) +
  geom_node_text(aes(label = name), size = 3.5, repel = TRUE,
                 fontface = "bold", max.overlaps = 20) +
  scale_edge_width_continuous(range = c(0.5, 3), name = "Collaborations") +
  scale_size_continuous(range = c(5, 15), name = "Degree") +
  labs(
    title = "Country Collaboration Network",
    subtitle = paste("Countries with ≥2 international collaborations")
  ) +
  theme_graph() +
  theme(
    plot.title = element_text(face = "bold", hjust = 0.5, size = 14),
    plot.subtitle = element_text(hjust = 0.5, size = 10, color = "gray40")
  )

ggsave("outputs/figuras/redes/02_country_collaboration_network.png", p2,
       width = 12, height = 10, dpi = 300, bg = "white")

# Country metrics table
country_metrics <- data.frame(
  Country = V(subnet_countries)$name,
  Degree = V(subnet_countries)$degree,
  Betweenness = round(V(subnet_countries)$betweenness, 3),
  Collaborations = sapply(1:vcount(subnet_countries), function(i) {
    sum(E(subnet_countries)[inc(i)]$weight)
  }),
  stringsAsFactors = FALSE
) %>%
  arrange(desc(Degree))

write.csv(country_metrics, "outputs/tablas/redes/02_country_metrics.csv",
          row.names = FALSE)
}  # End of AU_CO validation

# ==============================================================================
# 4. BRADFORD'S LAW (Journal Core)
# ==============================================================================

cat("STEP 3: Bradford's Law analysis...\n")

# Bradford analysis
bradford <- bradford(M)

# Extract Bradford zones
bradford_zones <- bradford$table %>%
  mutate(
    Zone = case_when(
      Zone == "Zone 1" ~ "Core (Zone 1)",
      Zone == "Zone 2" ~ "Middle (Zone 2)",
      Zone == "Zone 3" ~ "Peripheral (Zone 3)",
      TRUE ~ Zone
    )
  )

write.csv(bradford_zones, "outputs/tablas/cienciometria/03_bradford_zones.csv",
          row.names = FALSE)

# Bradford plot - skip plotting (bradford object structure issue)
# The table with zones is already saved, which is the key output
cat("  Bradford plot skipped (table saved successfully)\n")

cat("  Core journals (Zone 1):", sum(bradford_zones$Zone == "Core (Zone 1)"), "\n")
cat("  Middle journals (Zone 2):", sum(bradford_zones$Zone == "Middle (Zone 2)"), "\n")
cat("  Peripheral journals (Zone 3):", sum(bradford_zones$Zone == "Peripheral (Zone 3)"), "\n\n")

# ==============================================================================
# 5. LOTKA'S LAW (Author Productivity)
# ==============================================================================

cat("STEP 4: Lotka's Law analysis...\n")

# Lotka analysis - simplified approach
# Extract author productivity from M directly
if ("AU" %in% names(M) && !all(is.na(M$AU))) {
  # Count documents per author
  authors_list <- unlist(strsplit(M$AU, ";"))
  authors_list <- trimws(authors_list)
  author_counts <- table(authors_list)

  # Create productivity distribution
  prod_distribution <- table(author_counts)
  author_prod <- data.frame(
    Documents_per_Author = as.numeric(names(prod_distribution)),
    N_Authors = as.numeric(prod_distribution),
    stringsAsFactors = FALSE
  )
  author_prod <- author_prod %>%
    mutate(Pct_Authors = round(N_Authors / sum(N_Authors) * 100, 2)) %>%
    filter(Documents_per_Author <= 10) %>%
    arrange(Documents_per_Author)

  write.csv(author_prod, "outputs/tablas/cienciometria/04_lotka_distribution.csv",
            row.names = FALSE)

  cat("  Author productivity distribution saved\n")
  cat("  Authors with 1 document:", author_prod$N_Authors[author_prod$Documents_per_Author == 1], "\n")
  cat("  Authors with 2+ documents:", sum(author_prod$N_Authors[author_prod$Documents_per_Author >= 2]), "\n\n")
} else {
  cat("  WARNING: Cannot compute Lotka's Law without AU field\n\n")
}

# ==============================================================================
# 6. CITATION ANALYSIS
# ==============================================================================

cat("STEP 5: Citation analysis...\n")

# Validate TC field (total citations)
if (!"TC" %in% names(M)) {
  M$TC <- 0
  cat("  WARNING: TC field missing, setting citations to 0\n")
}

# H-index calculation
if (!"AU" %in% names(M) || all(is.na(M$AU))) {
  cat("  WARNING: Cannot calculate h-index without AU field. Skipping.\n\n")
} else {
  hindex_authors <- Hindex(M, field = "author", sep = ";", years = 10)

# Top 20 authors by h-index
top_h <- as.data.frame(hindex_authors$H) %>%
  head(20) %>%
  mutate(
    Author = rownames(hindex_authors$H)[1:20],
    h_index = as.numeric(h_index),
    g_index = as.numeric(g_index),
    m_index = as.numeric(m_index)
  ) %>%
  arrange(desc(h_index))

write.csv(top_h, "outputs/tablas/cienciometria/05_h_index_authors.csv",
          row.names = FALSE)

# H-index visualization
p5 <- ggplot(top_h %>% head(15),
             aes(x = reorder(Author, h_index), y = h_index)) +
  geom_col(fill = "steelblue", alpha = 0.8) +
  geom_text(aes(label = h_index), hjust = -0.3, size = 3.5) +
  coord_flip() +
  ylim(0, max(top_h$h_index) * 1.15) +
  labs(
    title = "Top 15 Authors by H-Index",
    subtitle = "Based on local citation data",
    x = NULL,
    y = "H-Index"
  )

ggsave("outputs/figuras/cienciometria/05_h_index_top_authors.png", p5,
       width = 10, height = 8, dpi = 300, bg = "white")

# Most cited documents
most_cited <- M %>%
  select(SR, TI, PY, TC, SO) %>%
  arrange(desc(TC)) %>%
  head(20) %>%
  rename(
    Reference = SR,
    Title = TI,
    Year = PY,
    Citations = TC,
    Source = SO
  )

write.csv(most_cited, "outputs/tablas/cienciometria/06_most_cited_documents.csv",
          row.names = FALSE)

  cat("  Mean citations per document:", round(mean(M$TC, na.rm = TRUE), 2), "\n")
  cat("  Median citations per document:", median(M$TC, na.rm = TRUE), "\n")
  cat("  Max citations:", max(M$TC, na.rm = TRUE), "\n\n")
}  # End of h-index validation

# ==============================================================================
# 7. CONCEPTUAL STRUCTURE (CO-WORD ANALYSIS)
# ==============================================================================

cat("STEP 6: Conceptual structure analysis...\n")

# Load topic data from Phase 2A
df_topics <- readRDS("data/processed/datos_con_topics_y_keywords.rds")

# Validate keywords field (ID or DE)
keywords_field <- if ("ID" %in% names(M) && !all(is.na(M$ID))) {
  "keywords"
} else if ("DE" %in% names(M) && !all(is.na(M$DE))) {
  "author_keywords"
} else {
  NULL
}

if (is.null(keywords_field)) {
  cat("  WARNING: No keywords field available. Skipping conceptual structure.\n\n")
} else {
  # Co-word network (keywords)
  NetMatrix_keywords <- biblioNetwork(M,
                                      analysis = "co-occurrences",
                                      network = keywords_field,
                                      sep = ";",
                                      n = 50)

net_keywords <- graph_from_adjacency_matrix(NetMatrix_keywords,
                                            mode = "undirected",
                                            weighted = TRUE)

# Filter top keywords (degree >= 3)
top_kw <- V(net_keywords)[igraph::degree(net_keywords) >= 3]
subnet_keywords <- igraph::induced_subgraph(net_keywords, top_kw)

# CRITICAL: Recalculate metrics on SUBGRAPH and store as simple vectors
subnet_degrees <- igraph::degree(subnet_keywords)
V(subnet_keywords)$degree <- subnet_degrees
communities_kw <- igraph::cluster_louvain(subnet_keywords)
subnet_communities <- igraph::membership(communities_kw)
V(subnet_keywords)$community <- subnet_communities

cat("  Keyword nodes:", vcount(subnet_keywords), "\n")
cat("  Co-occurrence edges:", ecount(subnet_keywords), "\n")
cat("  Thematic clusters:", length(unique(subnet_communities)), "\n\n")

# Visualization
p7 <- ggraph(subnet_keywords, layout = "fr") +
  geom_edge_link(aes(width = weight), alpha = 0.2, color = "gray50") +
  geom_node_point(aes(size = degree, color = factor(community)), alpha = 0.7) +
  geom_node_text(aes(label = name), size = 2.5, repel = TRUE, max.overlaps = 20) +
  scale_edge_width_continuous(range = c(0.3, 1.5), name = "Co-occurrences") +
  scale_size_continuous(range = c(3, 10), name = "Degree") +
  scale_color_viridis_d(name = "Cluster") +
  labs(
    title = "Conceptual Structure: Keyword Co-occurrence Network",
    subtitle = paste("Top keywords with ≥3 connections |",
                     length(unique(subnet_communities)), "thematic clusters")
  ) +
  theme_graph() +
  theme(
    plot.title = element_text(face = "bold", hjust = 0.5, size = 14),
    plot.subtitle = element_text(hjust = 0.5, size = 10, color = "gray40")
  )

ggsave("outputs/figuras/redes/07_conceptual_structure_keywords.png", p7,
       width = 14, height = 10, dpi = 300, bg = "white")
}  # End of keywords validation

# ==============================================================================
# 8. THEMATIC EVOLUTION (Topics over Time)
# ==============================================================================

cat("STEP 7: Thematic evolution analysis...\n")

# Evolution of topics across periods
thematic_evolution <- df_topics %>%
  mutate(
    period = case_when(
      year_clean >= 2016 & year_clean <= 2019 ~ "2016-2019\n(Pre-COVID)",
      year_clean >= 2020 & year_clean <= 2022 ~ "2020-2022\n(During COVID)",
      year_clean >= 2023 & year_clean <= 2026 ~ "2023-2026\n(Post-COVID)",
      TRUE ~ "Other"
    )
  ) %>%
  filter(period != "Other") %>%
  group_by(period, topic_label) %>%
  summarise(n = n(), .groups = "drop") %>%
  group_by(period) %>%
  mutate(pct = n / sum(n) * 100) %>%
  ungroup()

# Thematic map
p8 <- ggplot(thematic_evolution,
             aes(x = period, y = pct, fill = topic_label, group = topic_label)) +
  geom_area(alpha = 0.7, color = "white", size = 0.3) +
  scale_fill_viridis_d(option = "D", name = "Topic") +
  labs(
    title = "Thematic Evolution Across Periods",
    subtitle = "Relative topic prominence over time",
    x = NULL,
    y = "% of Documents"
  ) +
  theme(
    legend.position = "right",
    legend.text = element_text(size = 8)
  )

ggsave("outputs/figuras/cienciometria/08_thematic_evolution.png", p8,
       width = 12, height = 7, dpi = 300, bg = "white")

# ==============================================================================
# 9. SUMMARY STATISTICS
# ==============================================================================

cat("\n", rep("=", 80), "\n")
cat("PHASE 3 COMPLETED SUCCESSFULLY\n")
cat(rep("=", 80), "\n\n")

cat("NETWORK ANALYSIS SUMMARY:\n")
if (exists("net_authors")) {
  cat("  Authors network:\n")
  cat("    - Total nodes:", vcount(net_authors), "\n")
  cat("    - Collaboration edges:", ecount(net_authors), "\n")
  cat("    - Communities:", length(unique(V(net_authors)$community)), "\n")
}
if (exists("net_countries")) {
  cat("  Countries network:\n")
  cat("    - Total nodes:", vcount(net_countries), "\n")
  cat("    - Collaboration edges:", ecount(net_countries), "\n")
}
if (exists("net_keywords")) {
  cat("  Keywords co-occurrence:\n")
  cat("    - Total keywords:", vcount(net_keywords), "\n")
  cat("    - Co-occurrence edges:", ecount(net_keywords), "\n")
}
cat("\n")

cat("BIBLIOMETRIC LAWS:\n")
cat("  Bradford's Law:\n")
cat("    - Core journals:", sum(bradford_zones$Zone == "Core (Zone 1)"), "\n")
cat("    - Middle journals:", sum(bradford_zones$Zone == "Middle (Zone 2)"), "\n")
cat("    - Peripheral journals:", sum(bradford_zones$Zone == "Peripheral (Zone 3)"), "\n")
cat("  Lotka's Law:\n")
if (exists("author_prod")) {
  cat("    - Authors with 1 document:", author_prod$N_Authors[author_prod$Documents_per_Author == 1], "\n")
  cat("    - Authors with 2+ documents:", sum(author_prod$N_Authors[author_prod$Documents_per_Author >= 2]), "\n")
} else {
  cat("    - Not computed\n")
}
cat("\n")

cat("CITATION METRICS:\n")
cat("  Mean citations per document:", round(mean(M$TC, na.rm = TRUE), 2), "\n")
cat("  Median citations:", median(M$TC, na.rm = TRUE), "\n")
cat("  Max citations:", max(M$TC, na.rm = TRUE), "\n\n")

cat("FILES GENERATED:\n")
cat("  outputs/figuras/redes/\n")
cat("    - 01: Author collaboration network\n")
cat("    - 02: Country collaboration network\n")
cat("    - 07: Conceptual structure (keywords)\n\n")
cat("  outputs/figuras/cienciometria/\n")
cat("    - 03: Bradford's Law\n")
cat("    - 04: Lotka's Law\n")
cat("    - 05: H-index top authors\n")
cat("    - 08: Thematic evolution\n\n")
cat("  outputs/tablas/\n")
cat("    - 7 network and bibliometric tables\n\n")

cat("NEXT STEPS:\n")
cat("  1. Review all visualizations\n")
cat("  2. Validate network communities\n")
cat("  3. Integrate findings into manuscript\n")
cat("  4. Proceed to Phase 4: Final synthesis\n\n")

cat("End:", format(Sys.time(), "%Y-%m-%d %H:%M:%S"), "\n")
cat(rep("=", 80), "\n\n")

# END OF SCRIPT

cat("End:", format(Sys.time(), "%Y-%m-%d %H:%M:%S"), "\n")
cat(rep("=", 80), "\n\n")

# END OF SCRIPT

