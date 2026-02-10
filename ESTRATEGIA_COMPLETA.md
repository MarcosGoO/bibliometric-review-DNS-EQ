# 📊 ESTRATEGIA COMPLETA - ANÁLISIS BIBLIOMÉTRICO
## Didáctica de Ciencias Naturales y Calidad Educativa (2016-2026)

---

## 🎯 OBJETIVO DEL PROYECTO

Producir un **artículo bibliométrico de alta calidad** (Q1/Q2) que:
- Mapee el estado del arte en didáctica de ciencias naturales
- Identifique tendencias emergentes y gaps de investigación
- Use visualizaciones innovadoras (no estándar bibliometrix)
- Aporte valor diferenciador mediante análisis temático profundo

---

## 📍 ESTADO ACTUAL DEL PROYECTO

### ✅ COMPLETADO - Fase 1: Diagnóstico Inicial

**Datos consolidados:**
- **335 documentos únicos** de Scopus (226) + WoS (152)
- **43 duplicados eliminados** (11.38% solapamiento)
- **Periodo:** 2016-2026
- **Calidad:** 100% completitud en campos críticos

**Archivos generados:**
```
outputs/
├── datos_fusionados.csv              # Dataset limpio principal
├── 01_diagnostico_completo.xlsx      # Excel multi-hoja con resumen
├── figuras/
│   ├── 01_produccion_anual.png       # Tendencia temporal
│   ├── 02_tipos_documento.png        # Distribución de tipos
│   └── 03_top_paises.png             # Mapa geográfico
└── tablas/
    ├── 01_completitud_campos.csv     # Métricas de calidad
    ├── 02_produccion_anual.csv       # Serie temporal
    └── 03_top_journals.csv           # Top revistas
```

**Hallazgos clave:**
1. **Explosión 2025:** 99 docs (+90% vs 2024) - campo en consolidación
2. **Punto inflexión 2021:** +107% marca cambio post-pandemia
3. **Gap keywords:** Solo 40% tienen keywords → requiere extracción NLP
4. **Gap geográfico:** América Latina sub-representada (oportunidad)
5. **Alta fragmentación:** Sin journal dominante → análisis de clusters necesario

---

## 🚀 DECISIONES METODOLÓGICAS TOMADAS

### Enfoque seleccionado:
✅ **D) Análisis comprehensivo** (temporal + geográfico + impacto + temático)

### Visualización:
✅ **B) Gráficos ggplot2 personalizados** con control total

### Keywords faltantes:
✅ **B) Extracción desde abstracts con NLP** (topic modeling + TF-IDF)

### Filtros adicionales:
✅ **Sin filtros por citaciones** - mantener corpus completo (335 docs)
✅ **Todos los idiomas** - pero identificar patrones por idioma
✅ **Sin exclusiones geográficas** - mapear diversidad global

---

## 📋 PLAN DE IMPLEMENTACIÓN COMPLETO

### 🔵 FASE 2A: Análisis Temático y Extracción de Keywords (NLP)

**Objetivo:** Descubrir temas latentes y extraer keywords de abstracts

#### 2A.1 - Preprocesamiento de Texto
- [ ] Cargar abstracts desde `datos_fusionados.csv`
- [ ] Limpieza de texto:
  - Convertir a minúsculas
  - Eliminar stopwords (inglés + español)
  - Tokenización
  - Lematización/Stemming
  - Eliminar números y puntuación
- [ ] Crear corpus limpio

**Output esperado:**
- `outputs/data/processed/corpus_cleaned.rds`
- `outputs/tablas/04_texto_preprocesado_stats.csv`

#### 2A.2 - Análisis TF-IDF y Extracción de Keywords
- [ ] Calcular TF-IDF para cada documento
- [ ] Extraer top 5-10 términos por documento
- [ ] Añadir keywords extraídas al dataset principal
- [ ] Combinar con keywords originales (cuando existan)

**Output esperado:**
- `outputs/data/processed/datos_con_keywords_nlp.csv`
- `outputs/tablas/05_keywords_tfidf_ranking.csv`

#### 2A.3 - Topic Modeling (LDA)
- [ ] Optimizar número de topics (k = 6-10)
  - Usar métricas: perplexity, coherence
  - Probar k = 5, 6, 7, 8, 9, 10
- [ ] Entrenar modelo LDA óptimo
- [ ] Asignar topic dominante a cada documento
- [ ] Interpretar y etiquetar topics manualmente

**Topics esperados (hipótesis):**
1. Technology-Enhanced Learning
2. Inquiry-Based Science Education
3. Assessment & Evaluation
4. Teacher Professional Development
5. STEM Integration
6. Equity & Inclusion in Science Ed
7. Environmental/Sustainability Education
8. Conceptual Change & Misconceptions

**Output esperado:**
- `outputs/data/processed/lda_model.rds`
- `outputs/data/processed/datos_con_topics.csv`
- `outputs/tablas/06_topics_descripcion.csv`

#### 2A.4 - Visualizaciones Temáticas

**Gráficos a generar:**

**1. Topic Distribution Heatmap**
- Eje X: Topics
- Eje Y: Años (2016-2026)
- Color: Proporción de documentos
- Mostrar evolución temporal de temas

**2. Alluvial Diagram (Sankey)**
- Flujo de topics entre periodos:
  - 2016-2019 → 2020-2022 → 2023-2026
- Identificar temas emergentes vs declinantes

**3. Word Clouds por Topic**
- 6-8 word clouds (uno por topic)
- Tamaño según frecuencia TF-IDF
- Paleta de colores diferenciada

**4. Co-occurrence Network de Keywords**
- Nodos: Keywords (tamaño = frecuencia)
- Aristas: Co-ocurrencia en mismo documento
- Layout: Fruchterman-Reingold
- Clustering por modularidad

**5. Trend Topics Timeline**
- Gráfico de líneas múltiples
- Mostrar proporción de cada topic por año
- Identificar "burst topics" (explosiones súbitas)

**Output esperado:**
```
outputs/figuras/tematicas/
├── 04_topics_heatmap.png
├── 05_topics_evolution_sankey.html (interactivo)
├── 06_wordclouds_por_topic.png (grid 2x4)
├── 07_keywords_cooccurrence_network.png
└── 08_trend_topics_timeline.png
```

---

### 🟢 FASE 2B: Análisis de Redes de Colaboración

**Objetivo:** Mapear estructuras de colaboración científica

#### 2B.1 - Red de Co-autoría

**Análisis a realizar:**
- [ ] Extraer autores y afiliaciones
- [ ] Construir red no dirigida (autores = nodos)
- [ ] Calcular métricas:
  - Degree centrality
  - Betweenness centrality
  - Closeness centrality
  - Clustering coefficient
  - Componentes conectados

**Output esperado:**
- `outputs/data/processed/coautoria_network.rds`
- `outputs/tablas/07_autores_metricas_centrality.csv`

**Visualización:**
- **Grafo de co-autoría** (top 100 autores)
  - Nodos coloreados por país/institución
  - Tamaño = productividad (# docs)
  - Grosor arista = fuerza colaboración
  - Layout: Kamada-Kawai
- **Identificar clusters/comunidades** (algoritmo Louvain)

**Output:**
- `outputs/figuras/redes/09_coautoria_network.png`
- `outputs/figuras/redes/10_coautoria_clusters.png`

#### 2B.2 - Red de Co-citación

**Análisis a realizar:**
- [ ] Extraer referencias citadas (campo `CR`)
- [ ] Construir matriz de co-citación
- [ ] Identificar documentos "puente" (high betweenness)
- [ ] Detectar frentes de investigación (clusters)

**Output esperado:**
- `outputs/data/processed/cocitacion_network.rds`
- `outputs/tablas/08_documentos_mas_cocitados.csv`

**Visualización:**
- **Mapa de co-citación** (top 50 referencias)
  - Clusters = frentes de investigación
  - Etiquetar autores clave
  - Resaltar "sleeping beauties"

**Output:**
- `outputs/figuras/redes/11_cocitacion_map.png`

#### 2B.3 - Acoplamiento Bibliográfico

**Análisis a realizar:**
- [ ] Calcular similaridad entre documentos
- [ ] Identificar grupos temáticos
- [ ] Comparar con clusters de topic modeling

**Visualización:**
- **Mapa de similaridad temática**
  - Nodos = documentos del corpus
  - Color = topic LDA asignado
  - Posición = similaridad bibliográfica

**Output:**
- `outputs/figuras/redes/12_acoplamiento_bibliografico.png`

#### 2B.4 - Red de Journals

**Análisis a realizar:**
- [ ] Extraer journals y citaciones entre ellos
- [ ] Calcular centralidad de journals
- [ ] Identificar journals "gatekeepers"

**Visualización:**
- **Chord Diagram** journals ↔ journals
  - Mostrar flujo de citaciones
  - Identificar ecosistemas de journals

**Output:**
- `outputs/figuras/redes/13_journals_chord_diagram.png`
- `outputs/tablas/09_journals_centrality.csv`

#### 2B.5 - Mapa de Colaboración Internacional

**Análisis a realizar:**
- [ ] Extraer países de afiliaciones
- [ ] Construir matriz país-país (co-autoría internacional)
- [ ] Calcular índice de internacionalización por país

**Visualización:**
- **Mapa mundial interactivo** (opcional: usar plotly)
  - Nodos = países (tamaño = productividad)
  - Aristas = colaboraciones
  - Gradiente de color = intensidad colaboración

**Output:**
- `outputs/figuras/redes/14_colaboracion_internacional_map.html`
- `outputs/tablas/10_colaboracion_internacional.csv`

---

### 🟡 FASE 2C: Análisis de Impacto y Citaciones

**Objetivo:** Identificar documentos, autores y journals de alto impacto

#### 2C.1 - Métricas de Autores

**Análisis a realizar:**
- [ ] Calcular por autor:
  - Total de documentos
  - Total de citaciones
  - H-index
  - M-index (h-index normalizado por años de carrera)
  - G-index
  - Citaciones por documento (promedio)

**Output esperado:**
- `outputs/tablas/11_autores_top50_metricas.csv`

**Visualización:**
- **Scatter plot: Productividad vs Impacto**
  - Eje X: # documentos
  - Eje Y: Total citaciones
  - Tamaño burbuja: H-index
  - Color: País
  - Identificar "superstars" vs "one-hit wonders"

**Output:**
- `outputs/figuras/impacto/15_autores_productividad_vs_impacto.png`

#### 2C.2 - Distribución de Citaciones

**Análisis a realizar:**
- [ ] Histograma de citaciones
- [ ] Identificar "highly cited papers" (top 10%)
- [ ] Identificar "sleeping beauties" (citaciones tardías)
- [ ] Calcular vida media de citaciones (half-life)

**Output esperado:**
- `outputs/tablas/12_distribucion_citaciones.csv`
- `outputs/tablas/13_highly_cited_papers.csv`
- `outputs/tablas/14_sleeping_beauties.csv`

**Visualización:**
- **Gráfico de distribución** (histogram + densidad)
- **Timeline de sleeping beauties**
  - Mostrar evolución de citaciones año a año
  - Identificar cuándo "despertaron"

**Output:**
- `outputs/figuras/impacto/16_distribucion_citaciones.png`
- `outputs/figuras/impacto/17_sleeping_beauties_timeline.png`

#### 2C.3 - Análisis de Journals de Alto Impacto

**Análisis a realizar:**
- [ ] Por journal calcular:
  - Total de artículos en corpus
  - Citaciones totales
  - Citaciones promedio por artículo
  - H-index del journal (en este corpus)
  - Cuartil (Q1/Q2/Q3/Q4) según SCImago/JCR

**Output esperado:**
- `outputs/tablas/15_journals_impacto.csv`

**Visualización:**
- **Bubble chart: Journals**
  - Eje X: # artículos
  - Eje Y: Citaciones promedio
  - Tamaño: Total citaciones
  - Color: Cuartil
  - Etiquetar top 10

**Output:**
- `outputs/figuras/impacto/18_journals_impacto_bubble.png`

#### 2C.4 - Análisis Temporal de Citaciones

**Análisis a realizar:**
- [ ] Calcular citaciones por año de publicación
- [ ] Identificar años "dorados" (alta productividad + alto impacto)
- [ ] Calcular tasa de citación inmediata (2 años post-publicación)

**Visualización:**
- **Gráfico dual-eje:**
  - Eje primario: # documentos por año
  - Eje secundario: Citaciones promedio por año
  - Identificar correlación

**Output:**
- `outputs/figuras/impacto/19_citaciones_temporales.png`

---

### 🔴 FASE 3: Generación de Figuras Finales para Publicación

**Objetivo:** Crear 12-15 figuras de alta calidad (300+ DPI) listas para journal

#### 3.1 - Criterios de Calidad

Todas las figuras deben cumplir:
- **Resolución:** 300 DPI mínimo (600 DPI para gráficos de línea)
- **Formato:** PNG para web, PDF/EPS para publicación
- **Tamaño:** Width = 6.5" (single column) o 13" (double column)
- **Fuentes:** Arial o Times New Roman, 8-10pt mínimo
- **Paleta:** Colorblind-friendly (viridis, RColorBrewer)
- **Etiquetas:** Todas las ejes claramente etiquetados
- **Leyenda:** Posicionada sin obstruir datos
- **Títulos:** Informativos pero concisos

#### 3.2 - Lista de Figuras Finales

**FIGURA 1:** Producción anual 2016-2026 (con línea de tendencia)
- Mejorar versión actual con intervalos de confianza
- Anotar eventos clave (ej. COVID-19)

**FIGURA 2:** Distribución geográfica (mapa mundial)
- Choropleth map o circle map
- Gradiente de color por productividad

**FIGURA 3:** Top 20 journals (bar chart horizontal)
- Incluir cuartiles con color coding
- Añadir citaciones promedio como marcador secundario

**FIGURA 4:** Topics evolution (alluvial/sankey)
- 3 periodos: Pre-COVID, Durante-COVID, Post-COVID
- Flujo de temas dominantes

**FIGURA 5:** Topics heatmap temporal
- Matriz años × topics
- Color intensity = proporción

**FIGURA 6:** Keywords co-occurrence network
- Grafo de red con clustering
- Top 50-100 keywords

**FIGURA 7:** Red de co-autoría (clusters geográficos)
- Grafo con comunidades detectadas
- Etiquetar autores centrales

**FIGURA 8:** Mapa de co-citación (frentes de investigación)
- Identificar 4-6 clusters temáticos
- Etiquetar documentos seminales

**FIGURA 9:** Productividad vs Impacto (autores)
- Scatter plot con líneas de referencia
- Identificar cuadrantes

**FIGURA 10:** Distribución de citaciones (histogram + box plot)
- Mostrar asimetría de la distribución
- Identificar outliers

**FIGURA 11:** Colaboración internacional (chord diagram o mapa de flujo)
- Mostrar intensidad de colaboración país-país

**FIGURA 12:** Timeline de topics emergentes
- Line chart múltiple
- Identificar inflexiones

**FIGURA 13 (opcional):** Word clouds por topic (grid 2×4)

**FIGURA 14 (opcional):** Treemap de áreas temáticas
- Jerarquía: Topic → Subtema → Keywords

**FIGURA 15 (opcional):** Sleeping beauties showcase
- Gráficos individuales de 3-5 casos

#### 3.3 - Generación Automatizada

Crear script que:
- [ ] Regenere todas las figuras con parámetros finales
- [ ] Exporte en múltiples formatos (.png, .pdf, .eps)
- [ ] Genere versiones B/W para revisores
- [ ] Cree archivo con specs de cada figura (para Methods)

**Output:**
```
outputs/figuras/FINAL/
├── Figure_01_annual_production.png
├── Figure_01_annual_production.pdf
├── Figure_02_geographic_distribution.png
├── Figure_02_geographic_distribution.pdf
├── ...
└── figure_specifications.csv
```

---

### 🟣 FASE 4: Generación de Tablas para Publicación

**Objetivo:** Crear tablas estilo APA/journal-ready

#### 4.1 - Lista de Tablas Principales

**TABLE 1:** Descriptive statistics of the corpus
- Total documents, years, countries, journals, authors
- Document types distribution
- Language distribution

**TABLE 2:** Top 20 most productive journals
- Journal name, documents, citations, avg citations, quartile, h-index

**TABLE 3:** Top 20 most productive countries
- Country, documents, citations, single-country papers, international collaborations

**TABLE 4:** Top 30 most productive authors
- Author, affiliation, country, documents, citations, h-index

**TABLE 5:** Topic modeling results
- Topic ID, label, top 10 keywords, # docs, % corpus

**TABLE 6:** Most cited documents in the corpus
- Title, authors, year, journal, citations, topic

**TABLE 7:** Network metrics summary
- Co-authorship network stats
- Co-citation network stats
- Bibliographic coupling stats

**TABLE 8 (optional):** Keyword frequency ranking
- Top 50 keywords, frequency, TF-IDF score

**TABLE 9 (optional):** Emerging vs declining topics
- Topic, period 1 %, period 2 %, period 3 %, trend

#### 4.2 - Formato de Tablas

Exportar en 3 formatos:
- **CSV** para análisis adicional
- **Excel** con formato condicional (para revisión interna)
- **Word/LaTeX** listas para copiar-pegar en manuscrito

**Output:**
```
outputs/tablas/FINAL/
├── Table_01_corpus_descriptives.csv
├── Table_01_corpus_descriptives.docx
├── Table_02_top_journals.csv
├── Table_02_top_journals.docx
├── ...
└── tables_latex_code.txt
```

---

## 📊 ESTRUCTURA DE DATOS UNIFICADA

### Dataset principal integrado:

Al final de Fase 2, debes tener un dataset consolidado con TODOS estos campos:

```csv
ID, Title, Authors, Year, Journal, DOI, Abstract, 
Keywords_Original, Keywords_NLP_Extracted, Keywords_Combined,
Topic_LDA_ID, Topic_LDA_Label, Topic_Probability,
Country_First_Author, Countries_All, Institutions,
Citations, Citations_per_Year, Highly_Cited_Flag,
Author_First_HIndex, Journal_Quartile, Journal_HIndex,
Language, Document_Type, Open_Access,
Coauthors_Count, International_Collaboration_Flag,
Network_Degree, Network_Betweenness,
Database_Source, ...
```

**Archivo final:**
- `outputs/data/FINAL/corpus_completo_enriquecido.csv` (para artículo)
- `outputs/data/FINAL/corpus_completo_enriquecido.rds` (para análisis adicionales)

---

## 📝 FASE 5: Escritura del Manuscrito

**Objetivo:** Producir draft completo en LaTeX/Word

### 5.1 - Estructura del Artículo (Bibliometric Study)

**Title:** (propuesta)
"Mapping the Landscape of Science Education and Educational Quality: A Bibliometric Analysis of Trends, Collaborations, and Emerging Topics (2016-2026)"

**Abstract:** (250 words)
- Background & motivation
- Methods (corpus, databases, analysis)
- Key findings (3-4 hallazgos principales)
- Implications for research & practice

**Keywords:** (6-8)
Science education, Educational quality, Bibliometrics, Topic modeling, Research trends

---

**1. INTRODUCTION**
- 1.1 Background on science education research
- 1.2 Importance of bibliometric studies
- 1.3 Research questions:
  - RQ1: What are the temporal trends in publication output?
  - RQ2: What are the main thematic areas and their evolution?
  - RQ3: What are the patterns of international collaboration?
  - RQ4: Who are the most influential authors/journals?
- 1.4 Structure of the paper

**2. MATERIALS AND METHODS**
- 2.1 Data collection
  - Search strategy (keywords, Boolean operators)
  - Databases: Scopus & Web of Science
  - Inclusion/exclusion criteria
  - Final corpus: 335 documents
- 2.2 Data processing
  - Deduplication methodology
  - Quality assessment
  - NLP for keyword extraction
- 2.3 Analytical approach
  - Bibliometric indicators
  - Topic modeling (LDA, k=X)
  - Network analysis (co-authorship, co-citation)
  - Statistical tools: R/bibliometrix
- 2.4 Limitations

**3. RESULTS**
- 3.1 Descriptive statistics (TABLE 1)
  - Temporal distribution (FIGURE 1)
  - Geographic distribution (FIGURE 2)
  - Document types & languages
- 3.2 Most productive entities
  - Journals (TABLE 2, FIGURE 3)
  - Countries (TABLE 3)
  - Authors (TABLE 4)
  - Institutions
- 3.3 Thematic analysis
  - Topic modeling results (TABLE 5, FIGURE 4)
  - Topic evolution over time (FIGURE 5)
  - Keywords analysis (FIGURE 6)
  - Emerging vs declining themes (TABLE 9)
- 3.4 Collaboration patterns
  - Co-authorship network (FIGURE 7, TABLE 7)
  - International collaboration (FIGURE 11)
  - Network metrics interpretation
- 3.5 Citation and impact analysis
  - Most cited papers (TABLE 6)
  - Citation distribution (FIGURE 10)
  - Influential works (co-citation, FIGURE 8)
  - Sleeping beauties
- 3.6 Intellectual structure
  - Research fronts identification
  - Evolution of paradigms

**4. DISCUSSION**
- 4.1 Key findings interpretation
  - Growth dynamics (explosion in 2025, post-COVID recovery)
  - Thematic shifts (technology integration, equity focus)
  - Geographic patterns (Europe/Asia dominance, LATAM gap)
- 4.2 Comparison with prior bibliometric studies
- 4.3 Implications for research
  - Identified gaps (e.g., LATAM under-representation)
  - Promising areas for future work
- 4.4 Implications for practice
  - Policy recommendations
  - Teacher education priorities
- 4.5 Limitations
  - Language bias (96% English)
  - Database coverage
  - Keyword extraction challenges

**5. CONCLUSIONS**
- Summary of contributions
- Future research directions
- Closing statement

**REFERENCES** (100-150 refs)

**SUPPLEMENTARY MATERIALS** (online)
- Full dataset (CSV)
- Network graphs (interactive HTML)
- Complete topic-keyword distributions

---

### 5.2 - Generación del Documento

**Opción A: LaTeX (recomendado para Q1)**
- Usar template de journal target (ej. Elsevier/Springer)
- Incluir figuras en alta resolución
- Bibliografía con BibTeX

**Opción B: Word (para colaboración)**
- Usar estilos APA 7th
- Insertar tablas/figuras con captions
- Referencias con Mendeley/Zotero

**Herramientas sugeridas:**
- Overleaf (LaTeX colaborativo online)
- Authorea (markdown → LaTeX/Word)
- R Markdown → PDF via pandoc

---

## 🎯 MÉTRICAS DE ÉXITO

### Indicadores que el artículo debe cumplir para publicación Q1/Q2:

**Metodología:**
- ✅ Corpus >300 documentos
- ✅ Duplicados <15% solapamiento
- ✅ Topic modeling con validación (coherence scores)
- ✅ Network analysis con métricas estándar
- ✅ Reproducibilidad (código disponible)

**Visualizaciones:**
- ✅ 10-15 figuras de alta calidad (300+ DPI)
- ✅ Colorblind-friendly palettes
- ✅ Publication-ready (sin edición adicional)

**Tablas:**
- ✅ 6-9 tablas bien formateadas
- ✅ Estadísticos descriptivos completos
- ✅ Ranking tables con criterios claros

**Novedad:**
- ✅ Uso de NLP para keyword extraction
- ✅ Análisis multi-dimensional (temporal + temático + red + impacto)
- ✅ Identificación de gaps geográficos/temáticos
- ✅ Visualizaciones no estándar (alluvial, chord, etc.)

**Escritura:**
- ✅ Estructura clara IMRAD
- ✅ Abstract <250 words
- ✅ Introduction con research gaps claros
- ✅ Discussion que conecta hallazgos con literatura
- ✅ Conclusiones con implications prácticas

---

## 🔄 WORKFLOW RECOMENDADO

### Para Claude Code en VSCode:

**PASO 1:** Leer todos los .md de contexto
- Este documento (ESTRATEGIA_COMPLETA.md)
- CONTEXTO_PROYECTO.md (resumen ejecutivo)
- HALLAZGOS_FASE1.md (resultados diagnóstico)

**PASO 2:** Cargar datos existentes
- `outputs/datos_fusionados.csv` (dataset principal)
- `outputs/01_diagnostico_completo.xlsx` (estadísticas)

**PASO 3:** Ejecutar Fase 2A (Análisis Temático)
- Implementar preprocesamiento de texto
- Ejecutar topic modeling
- Generar visualizaciones temáticas
- Validar resultados

**PASO 4:** Ejecutar Fase 2B (Redes)
- Construir matrices de adyacencia
- Calcular métricas de red
- Generar grafos
- Interpretar clusters

**PASO 5:** Ejecutar Fase 2C (Impacto)
- Calcular métricas de autores/journals
- Análisis de distribución de citaciones
- Identificar papers influyentes

**PASO 6:** Consolidar dataset final
- Integrar todos los análisis en un solo CSV
- Verificar integridad

**PASO 7:** Generar figuras finales
- Regenerar todas con specs de publicación
- Exportar en múltiples formatos

**PASO 8:** Generar tablas finales
- Formatear estilo journal
- Exportar en Word/LaTeX

**PASO 9:** Asistir en escritura del manuscrito
- Generar borradores de secciones
- Insertar tablas/figuras con captions
- Formatear referencias

---

## 📂 ESTRUCTURA FINAL DEL PROYECTO

```
article_didacsci/
│
├── README.md                          # Descripción general
├── ESTRATEGIA_COMPLETA.md            # Este documento
├── CONTEXTO_PROYECTO.md              # Resumen ejecutivo
├── HALLAZGOS_FASE1.md                # Resultados diagnóstico
│
├── data/
│   ├── raw/
│   │   ├── scopus_export_*.bib       # Original Scopus
│   │   └── savedrecs.bib             # Original WoS
│   └── processed/
│       ├── corpus_cleaned.rds        # Texto preprocesado
│       ├── lda_model.rds             # Modelo LDA
│       ├── coautoria_network.rds     # Red co-autoría
│       ├── cocitacion_network.rds    # Red co-citación
│       └── FINAL/
│           └── corpus_completo_enriquecido.csv  # Dataset final
│
├── outputs/
│   ├── figuras/
│   │   ├── tematicas/                # Figs de topics/keywords
│   │   ├── redes/                    # Figs de redes
│   │   ├── impacto/                  # Figs de citaciones
│   │   └── FINAL/                    # Figuras publicación (PNG+PDF)
│   ├── tablas/
│   │   └── FINAL/                    # Tablas publicación (CSV+DOCX)
│   └── reportes/
│       ├── fase2a_tematico.html      # Reporte interactivo Fase 2A
│       ├── fase2b_redes.html         # Reporte interactivo Fase 2B
│       └── fase2c_impacto.html       # Reporte interactivo Fase 2C
│
├── manuscript/
│   ├── main.tex                      # Manuscrito LaTeX
│   ├── main.docx                     # Manuscrito Word
│   ├── references.bib                # Referencias
│   └── supplementary/                # Materiales suplementarios
│
└── article_didacsci.Rproj            # Proyecto R
```

---

## ⚠️ CONSIDERACIONES IMPORTANTES

### 1. Calidad sobre cantidad
No incluir visualizaciones por incluirlas. Cada figura debe:
- Responder una pregunta de investigación
- Aportar insights no evidentes en tablas
- Ser interpretable sin leer el texto

### 2. Reproducibilidad
Todo análisis debe ser reproducible:
- Código bien comentado
- Seeds fijados (para LDA, clustering)
- Versiones de paquetes documentadas
- Dataset final compartible (sin copyright issues)

### 3. Consistencia visual
Mantener coherencia en:
- Paleta de colores (usar misma en todo el paper)
- Tamaños de fuente
- Estilo de etiquetas
- Formato de legends

### 4. Validación estadística
- Reportar intervalos de confianza
- Significancia cuando corresponda (p-values)
- Effect sizes (no solo significancia)
- Métricas de bondad de ajuste (LDA coherence, network modularity)

### 5. Interpretación cautelosa
- No sobre-interpretar clusters automáticos
- Validar topics con expertos del dominio
- Reconocer limitaciones (sesgo de idioma, cobertura BD)

---

## 🎓 JOURNALS TARGET (en orden de preferencia)

**Tier 1 (Q1 - alto impacto):**
1. **Journal of Research in Science Teaching** (IF ~4.5)
2. **International Journal of Science Education** (IF ~3.5)
3. **Science Education** (IF ~3.8)

**Tier 2 (Q1/Q2 - buen impacto):**
4. **Research in Science Education** (IF ~2.5)
5. **Studies in Science Education** (IF ~5.0, pero publica pocos artículos)
6. **International Journal of Science and Mathematics Education** (IF ~2.5)

**Tier 3 (Q2 - opción segura):**
7. **Research in Science & Technological Education** (IF ~2.0)
8. **Science & Education** (IF ~2.2)

**Criterios de selección:**
- Todos aceptan estudios bibliométricos
- Enfoque en didáctica de ciencias
- Proceso de peer-review riguroso pero justo
- Tiempo de revisión: 2-4 meses promedio

---

## 📞 NOTAS PARA CLAUDE CODE

**Contexto técnico:**
- Usuario tiene experiencia en RStudio pero limitada en R
- Prefiere explicaciones claras y código bien comentado
- Quiere innovación en visualizaciones (no bibliometrix estándar)
- Enfoque en producir paper Q1/Q2 publicable

**Estilo de trabajo:**
- Generar código funcional y explicarlo
- Priorizar calidad sobre velocidad
- Validar resultados antes de avanzar
- Documentar decisiones metodológicas

**Outputs esperados:**
- Scripts R modulares (uno por fase)
- Gráficos en alta resolución (300+ DPI)
- Tablas formateadas estilo journal
- Reportes intermedios en HTML/Markdown

**Comunicación:**
- Explicar términos técnicos cuando sea necesario
- Sugerir alternativas cuando haya decisiones metodológicas
- Alertar sobre posibles problemas (ej. sesgo de datos)

---

## ✅ CHECKLIST DE ENTREGABLES FINALES

### Datos:
- [ ] `corpus_completo_enriquecido.csv` con todos los campos
- [ ] Modelos entrenados guardados (.rds)
- [ ] Matrices de redes exportadas

### Visualizaciones:
- [ ] 12-15 figuras en PNG (300+ DPI)
- [ ] 12-15 figuras en PDF vectorial
- [ ] 3-5 gráficos interactivos HTML (opcional)

### Tablas:
- [ ] 6-9 tablas en CSV
- [ ] 6-9 tablas en DOCX formateadas
- [ ] Código LaTeX de tablas

### Reportes:
- [ ] Reporte Fase 2A (HTML con gráficos interactivos)
- [ ] Reporte Fase 2B (HTML con redes interactivas)
- [ ] Reporte Fase 2C (HTML con análisis citaciones)

### Manuscrito:
- [ ] Draft completo en LaTeX
- [ ] Draft completo en Word (opcional)
- [ ] Referencias en BibTeX
- [ ] Materiales suplementarios

### Documentación:
- [ ] README con instrucciones de reproducción
- [ ] Documento metodológico detallado
- [ ] Changelog de decisiones tomadas

---

## 🎯 RESULTADO FINAL ESPERADO

Un artículo bibliométrico que:
1. **Mapee comprehensivamente** el estado del arte en didáctica de ciencias
2. **Identifique trends emergentes** mediante topic modeling robusto
3. **Visualice patrones** de colaboración internacional
4. **Detecte gaps** temáticos y geográficos para futura investigación
5. **Provea insights accionables** para investigadores y policy-makers

Con **calidad metodológica suficiente** para:
- Pasar peer-review en journal Q1/Q2
- Ser citado como referencia en el campo
- Servir de modelo para futuros estudios bibliométricos

---

**Fecha de creación:** Febrero 2026  
**Última actualización:** Febrero 9, 2026  
**Versión:** 1.0  
**Estado:** Fase 1 completada, Fase 2-5 por ejecutar
