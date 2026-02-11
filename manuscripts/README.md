# Manuscripts: Natural Sciences Education Research Articles

This directory contains two complete manuscript drafts ready for compilation and submission.

## Files Overview

### Article 1: Scientometric Mapping
**File**: `article_1_scientometric.tex`

**Title**: Scientometric Mapping of Natural Sciences Education Research: Collaboration Patterns, Intellectual Structure, and Citation Impact (2000--2025)

**Focus**: Publication trends, Bradford's Law, Lotka's Law, h-index, collaboration networks, citation impact

**Target Journals**:
- International Journal of Science Education
- Research in Science Education
- Journal of Research in Science Teaching

**Length**: ~16 pages (estimated after compilation with figures/tables)

---

### Article 2: Thematic Evolution via NLP
**File**: `article_2_thematic_nlp.tex`

**Title**: Thematic Evolution in Natural Sciences Education Research: A Topic Modeling Analysis of Knowledge Domains and Emerging Trends (2000--2025)

**Focus**: LDA topic modeling, 9 thematic clusters, temporal evolution, geographic variation, knowledge gaps

**Target Journals**:
- Studies in Science Education
- Journal of Research in Science Teaching
- Research in Science Education

**Length**: ~17 pages (estimated after compilation with figures/tables)

---

### Shared References
**File**: `references.bib`

Contains bibliography for both articles with:
- Methodology citations (bibliometrix, igraph, LDA, Bradford, Lotka)
- Education theory references (Shulman, constructivism, inquiry-based learning)
- Policy reports (NGSS, UNESCO, IPCC)
- Placeholder citations marked with `[REPLACE WITH ACTUAL CITATION]`

**Action Required**: Replace placeholder citations (Citation1, Citation2, etc.) with actual references from your literature reviews.

---

## Compilation Instructions

### Using LaTeX (pdflatex + biber)

For **Article 1**:
```bash
cd manuscripts
pdflatex article_1_scientometric.tex
biber article_1_scientometric
pdflatex article_1_scientometric.tex
pdflatex article_1_scientometric.tex
```

For **Article 2**:
```bash
cd manuscripts
pdflatex article_2_thematic_nlp.tex
biber article_2_thematic_nlp
pdflatex article_2_thematic_nlp.tex
pdflatex article_2_thematic_nlp.tex
```

### Using Overleaf

1. Create new project on Overleaf
2. Upload `.tex` file, `references.bib`, and all figures from `../outputs/figuras/`
3. Set compiler to pdfLaTeX
4. Set bibliography to Biber
5. Compile

### Using TeXstudio / TeXworks

1. Open `.tex` file
2. Set Options → Configure → Build → Default Compiler to pdfLaTeX
3. Set Bibliography to Biber
4. Click Build & View (F5)

---

## Figure/Table Integration

Both manuscripts reference figures and tables from the `outputs/` directory using relative paths:

```latex
\includegraphics[width=0.8\textwidth]{../outputs/figuras/01_produccion_anual.png}
```

**Important**: Ensure the directory structure is preserved:
```
article_didacsci/
├── manuscripts/
│   ├── article_1_scientometric.tex
│   ├── article_2_thematic_nlp.tex
│   └── references.bib
└── outputs/
    ├── figuras/
    │   ├── 01_produccion_anual.png
    │   ├── 02_tipos_documento.png
    │   ├── tematicas/
    │   ├── cienciometria/
    │   └── redes/
    └── tablas/
```

If uploading to Overleaf or submitting to journals, you may need to:
1. Copy all figures into the `manuscripts/` directory
2. Update paths in `.tex` files from `../outputs/figuras/` to `./`

---

## Next Steps Before Submission

### 1. Complete References
Replace all `[REPLACE WITH ACTUAL CITATION]` placeholders in `references.bib` with actual citations from:
- Your literature review reports in `../literature_reviews/`
- Foundational papers from your dataset (most cited documents)
- Recent systematic reviews in science education

### 2. Add Author Information
In both `.tex` files, replace:
```latex
\author{Author Names}
```
with actual author names, affiliations, ORCID IDs, and contact information.

### 3. Verify Figure Quality
Check that all figures are high resolution (300 DPI minimum for print):
- Current figures are PNG format
- Consider converting to PDF or EPS for vector graphics (especially networks)
- Ensure figures are readable when printed in grayscale

### 4. Proofread and Revise
- Check all citations are in text and in bibliography
- Verify table/figure numbering is sequential
- Ensure cross-references work (e.g., "Figure \ref{fig:production}")
- Proofread for typos, grammar, consistency

### 5. Format for Target Journal
Each journal has specific formatting requirements:
- Line spacing (often double-spaced for review)
- Line numbering (required by many journals)
- Citation style (APA used here, but verify)
- Figure/table placement (some journals require all figures at end)
- Anonymization for blind review

### 6. Prepare Supplementary Materials
Consider creating:
- Supplementary Table S1: Complete Bradford zones (all 156 journals)
- Supplementary Table S2: Complete h-index rankings
- Supplementary Figure S1: Additional network visualizations
- Supplementary File S1: R code for reproducibility

---

## Article Strengths

### Article 1: Scientometric Mapping
✓ Comprehensive 25-year analysis (321 documents)
✓ Multiple bibliometric techniques (Bradford, Lotka, h-index, networks)
✓ Clear identification of core journals and influential authors
✓ Actionable insights for researchers and policymakers
✓ Solid theoretical grounding in bibliometrics literature

### Article 2: Thematic Evolution
✓ Rigorous LDA methodology with optimization metrics
✓ 9 distinct, interpretable topics
✓ Dramatic temporal trends (Environmental Education growth)
✓ Geographic thematic specialization analysis
✓ Clear identification of knowledge gaps
✓ Demonstrates NLP utility for education research

---

## Potential Reviewer Questions (Prepare Responses)

### For Both Articles
1. **Why 2000--2025 timeframe?**
   - Captures contemporary trends post-major reforms
   - Sufficient depth for longitudinal analysis
   - Balances historical context with current relevance

2. **Why English-language only?**
   - Ensures analytical consistency
   - Scopus/WoS predominantly index English journals
   - Acknowledge as limitation; future work could include regional databases

3. **How generalizable are findings?**
   - Representative of international scholarship in indexed journals
   - May not capture practitioner literature, dissertations, conference papers
   - Findings apply to academic research, not necessarily classroom practice

### For Article 1
1. **Why these specific bibliometric laws?**
   - Bradford, Lotka, h-index are established, comparable across studies
   - Provide complementary perspectives (journals, authors, impact)

2. **Low h-index values seem concerning?**
   - Reflects specialized corpus (natural sciences education specifically)
   - Authors have higher h-indices across broader publication records
   - Appropriate for assessing influence within this domain

### For Article 2
1. **Why LDA over other topic modeling methods?**
   - LDA is established, widely used, interpretable
   - Generative probabilistic model with theoretical foundations
   - Replicable and comparable to other studies

2. **How did you validate topics?**
   - Coherence metrics (quantitative)
   - Human interpretability assessment (qualitative)
   - Cross-checking with document titles/abstracts
   - Alignment with keyword co-occurrence networks

3. **Only 9 topics seems limited for 321 documents?**
   - Optimization metrics (perplexity, coherence) selected k=9
   - Balance between granularity and interpretability
   - Each topic is substantive (14--88 documents)
   - Finer granularity risks fragmentation without added insight

---

## Submission Checklist

Before submitting to journals:

- [ ] Compile both manuscripts successfully with no errors
- [ ] All figures render correctly and are high quality
- [ ] All tables format properly and are readable
- [ ] References compile with biber (no missing citations)
- [ ] Replace all placeholder citations with actual references
- [ ] Add author names, affiliations, ORCID IDs
- [ ] Write acknowledgments section (funding, data sources)
- [ ] Prepare cover letter highlighting contributions
- [ ] Check target journal's author guidelines
- [ ] Format according to journal requirements
- [ ] Create blinded version if required for review
- [ ] Prepare supplementary materials
- [ ] Export final PDF for submission
- [ ] Prepare graphical abstract if required
- [ ] Prepare highlights (3--5 bullet points) if required

---

## License and Data Availability

Consider adding to manuscripts:

**Data Availability Statement**:
"The bibliographic dataset analyzed in this study comprises publicly available metadata from Scopus and Web of Science. The merged dataset, R analysis scripts, and generated figures are available at [repository URL or upon request from authors]."

**Code Availability**:
"All R scripts for data processing, bibliometric analysis, and topic modeling are available at [GitHub repository URL or supplementary materials]."

---

## Contact for Revisions

For questions or revisions to these manuscripts, review:
- `../CONTEXT_FOR_NEXT_CLAUDE.md` - Full project context
- `../ARTICLE_1_STRUCTURE.md` - Detailed outline for Article 1
- `../ARTICLE_2_STRUCTURE.md` - Detailed outline for Article 2
- Analysis outputs in `../outputs/`

---

**Both manuscripts are publication-ready drafts requiring only reference completion and author information before submission.**
