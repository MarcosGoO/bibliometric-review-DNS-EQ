# Bibliometric Analysis: Science Education & Educational Quality (2016-2026)

[![R](https://img.shields.io/badge/R-4.0%2B-blue.svg)](https://www.r-project.org/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Status](https://img.shields.io/badge/Status-In%20Progress-orange.svg)]()

## 📋 Overview

This repository contains the code, data, and analysis for a comprehensive bibliometric study mapping the landscape of **science education and educational quality** research from 2016 to 2026. The study analyzes **335 unique documents** from Scopus and Web of Science, employing advanced text mining, topic modeling, and network analysis techniques.

---

## 🎯 Objectives

- Map temporal trends in science education research
- Identify thematic areas using NLP and topic modeling (LDA)
- Analyze collaboration patterns through co-authorship networks
- Detect research gaps (geographic, thematic, methodological)
- Provide actionable insights for researchers and policymakers

---

## 📊 Dataset

- **Total documents**: 335 unique articles
- **Sources**: Scopus (226) + Web of Science (152)
- **Duplicates removed**: 43 (11.38% overlap)
- **Period**: 2016-2026
- **Languages**: 96% English, 2.4% Spanish, <1% others
- **Data quality**: 100% completeness in critical fields

---

## 🔬 Methodology

### Phase 1: Initial Diagnostics ✅
- Data fusion and deduplication
- Quality assessment
- Temporal and geographic distribution analysis

### Phase 2A: Thematic Analysis (NLP) ✅
- **Text preprocessing**: Cleaning, tokenization, stemming
- **Keyword extraction**: TF-IDF (solved 60% missing keywords → 100% coverage)
- **Topic modeling**: Latent Dirichlet Allocation (LDA) with optimized k
- **Validation**: Probabilistic coherence scores
- **Temporal analysis**: Pre-COVID, During-COVID, Post-COVID periods

### Phase 2B: Network Analysis (In Progress)
- Co-authorship networks
- Co-citation analysis
- Bibliographic coupling
- International collaboration patterns

### Phase 2C: Impact Analysis (Planned)
- Author metrics (H-index, productivity)
- Citation distribution analysis
- Highly cited papers and "sleeping beauties"
- Journal impact assessment

---

## 📁 Project Structure

```
article_didacsci/
│
├── data/
│   ├── raw/                    # Original .bib files from Scopus/WoS
│   └── processed/              # Cleaned data, LDA models, DTM
│
├── outputs/
│   ├── figuras/                # Publication-ready visualizations (300 DPI)
│   │   └── tematicas/          # Topic modeling figures
│   └── tablas/                 # Statistical tables (CSV)
│
├── scripts/
│   ├── 00_instalacion_paquetes.R
│   ├── 01_diagnostico_inicial_ACTUALIZADO.R
│   └── 02A_analisis_tematico_NLP.R
│
└── README.md                   # This file
```

---

## 🛠️ Technologies & Tools

**Programming**: R 4.0+

**Key Packages**:
- `bibliometrix` - Core bibliometric analysis
- `tidyverse` - Data manipulation and visualization
- `tm`, `topicmodels`, `ldatuning` - Text mining and topic modeling
- `igraph`, `ggraph` - Network analysis
- `viridis`, `ggplot2` - Publication-quality visualizations

**Version Control**: Git + GitHub

---

## 🚀 Quick Start

### Prerequisites
- R 4.0 or higher
- RStudio (recommended)
- Git

### Installation

1. Clone the repository:
```bash
git clone https://github.com/MarcosGoO/bibliometric-review-DNS-EQ.git
cd bibliometric-review-DNS-EQ
```

2. Open the R project:
```r
# Open article_didacsci.Rproj in RStudio
```

3. Install required packages:
```r
source("scripts/00_instalacion_paquetes.R")
```

4. Run the analysis:
```r
# Phase 1: Initial diagnostics
source("scripts/01_diagnostico_inicial_ACTUALIZADO.R")

# Phase 2A: Thematic analysis
source("scripts/02A_analisis_tematico_NLP.R")
```

---

## 📈 Key Findings (Preliminary)

### Temporal Trends
- **2025 Explosion**: 99 documents (+90% vs 2024) - field consolidation phase
- **2021 Inflection Point**: +107% growth marks post-pandemic shift
- **Three phases**: Moderate growth (2016-2020) → Acceleration (2021-2024) → Explosion (2025)

### Geographic Distribution
- **Europe & Asia dominate**: Germany, Indonesia, Turkey lead
- **Latin America underrepresented**: <1% of corpus (gap identified)
- **High international collaboration**: Most papers multi-author, multi-country

### Thematic Insights (Phase 2A)
- **Dominant topics**: Technology-enhanced learning, inquiry-based education, assessment
- **Emerging themes**: AI in education, equity & social justice, sustainability
- **COVID-19 impact**: Shift towards remote learning and digital tools post-2020

---

## 📊 Visualizations

The project generates **publication-ready visualizations** (300 DPI, colorblind-friendly palettes):

- **Topics Heatmap**: Temporal evolution of research themes
- **Alluvial Diagram**: Topic transitions across Pre/During/Post-COVID periods
- **Word Clouds**: Visual representation of topic content
- **Keywords Co-occurrence Network**: Thematic structure with clustering
- **Trend Timeline**: Temporal patterns of topic prominence

---

## 📝 Citation

If you use this code or methodology, please cite:

```
[Author Name]. (2026). Mapping the Landscape of Science Education and
Educational Quality: A Bibliometric Analysis (2016-2026).
[Target Journal]. [DOI - pending publication]
```

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 👤 Author

**Marcos Elías Gómez Osorio**
- 📧 Email: [[Email](marcoseliasgom@gmail.com)]
- 🔗 LinkedIn: [[Your LinkedIn](https://www.linkedin.com/in/marcos-g%C3%B3mez-659b0938a/)]

---

## 🤝 Contributing

This is an academic research project. If you find issues or have suggestions:

1. Open an issue describing the problem/suggestion
2. For bug reports, include: R version, package versions, error messages
3. For methodology questions, refer to the literature cited in scripts

---

## 📚 References

**Key Methodological Sources**:
- Blei, D. M., et al. (2003). Latent Dirichlet allocation. *JMLR*, 3, 993-1022.
- Chen, C. (2017). Science mapping: A systematic review. *JDIS*, 2(2), 1-40.
- Mimno, D., et al. (2011). Optimizing semantic coherence in topic models. *EMNLP*.
- Aria, M., & Cuccurullo, C. (2017). bibliometrix: An R-tool for bibliometrics. *JOSS*, 2(15), 394.

---

**Last Updated**: February 2026
**Status**: Active Development
**Language**: R (scripts), English (documentation)
