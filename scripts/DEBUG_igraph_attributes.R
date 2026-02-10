################################################################################
# DEBUG SCRIPT: Diagnóstico de igraph attributes
################################################################################

library(bibliometrix)
library(igraph)

cat("Loading dataset...\n")
M <- readRDS("outputs/datos_fusionados.rds")

cat("\n=== CREATING AUTHOR NETWORK ===\n")
NetMatrix_authors <- biblioNetwork(M,
                                   analysis = "collaboration",
                                   network = "authors",
                                   sep = ";")

net_authors <- graph_from_adjacency_matrix(NetMatrix_authors,
                                          mode = "undirected",
                                          weighted = TRUE)

cat("Network created. Total vertices:", vcount(net_authors), "\n\n")

cat("=== CALCULATING DEGREE ===\n")
degree_vec <- degree(net_authors)
cat("Class of degree() result:", class(degree_vec), "\n")
cat("Type of degree() result:", typeof(degree_vec), "\n")
cat("Length:", length(degree_vec), "\n")
cat("First 5 values:\n")
print(head(degree_vec, 5))

cat("\n=== STORING AS VERTEX ATTRIBUTE ===\n")
V(net_authors)$degree <- degree_vec
cat("Degree attribute stored\n")

cat("\n=== TESTING ATTRIBUTE ACCESS ===\n")
attr_access <- V(net_authors)$degree
cat("Class of V(net_authors)$degree:", class(attr_access), "\n")
cat("Type of V(net_authors)$degree:", typeof(attr_access), "\n")
cat("Is it a list?:", is.list(attr_access), "\n")
cat("Length:", length(attr_access), "\n")
cat("First 5 values:\n")
print(head(attr_access, 5))

cat("\n=== TESTING COMPARISON ===\n")
cat("Attempting: V(net_authors)$degree >= 3\n")
tryCatch({
  test_comparison <- V(net_authors)$degree >= 3
  cat("SUCCESS! Comparison works\n")
  cat("Result class:", class(test_comparison), "\n")
  cat("Number of TRUE values:", sum(test_comparison), "\n")
}, error = function(e) {
  cat("ERROR:", e$message, "\n")
})

cat("\n=== TESTING SUBSETTING ===\n")
cat("Attempting: V(net_authors)[V(net_authors)$degree >= 3]\n")
tryCatch({
  top_authors <- V(net_authors)[V(net_authors)$degree >= 3]
  cat("SUCCESS! Subsetting works\n")
  cat("Number of top authors:", length(top_authors), "\n")
}, error = function(e) {
  cat("ERROR:", e$message, "\n")
})

cat("\n=== ALTERNATIVE APPROACH ===\n")
cat("Attempting with which()...\n")
tryCatch({
  idx <- which(V(net_authors)$degree >= 3)
  top_authors_alt <- V(net_authors)[idx]
  cat("SUCCESS with which()!\n")
  cat("Number of top authors:", length(top_authors_alt), "\n")
}, error = function(e) {
  cat("ERROR:", e$message, "\n")
})

cat("\n=== PACKAGE VERSIONS ===\n")
cat("igraph version:", as.character(packageVersion("igraph")), "\n")
cat("bibliometrix version:", as.character(packageVersion("bibliometrix")), "\n")

cat("\nDEBUG COMPLETED\n")
