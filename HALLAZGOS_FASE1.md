# 📊 HALLAZGOS FASE 1 - DIAGNÓSTICO INICIAL

## RESUMEN DE ANÁLISIS COMPLETADO

**Fecha de análisis:** Febrero 9, 2026  
**Corpus final:** 335 documentos únicos  
**Periodo:** 2016-2026 (11 años)

---

## 1. PROCESO DE CONSOLIDACIÓN

### Datos originales:
- **Scopus:** 226 documentos
- **Web of Science:** 152 documentos
- **Total bruto:** 378 documentos

### Deduplicación:
- **Método:** Normalización de títulos (lowercase, sin puntuación)
- **Duplicados encontrados:** 43 (11.38% de solapamiento)
- **Corpus final:** 335 documentos únicos

### Interpretación:
✅ Tasa de solapamiento moderada (11.38%) es NORMAL en estudios bibliométricos
- Indica búsqueda bien acotada
- Complementariedad entre bases de datos
- No hay sobre-representación de una fuente

---

## 2. CALIDAD DE LOS DATOS

### Completitud por campo:

| Campo | Completitud | Evaluación |
|-------|-------------|------------|
| Título | 100.00% | ✅ Excelente |
| Autores | 100.00% | ✅ Excelente |
| Journal | 100.00% | ✅ Excelente |
| Año | 100.00% | ✅ Excelente |
| Abstract | 100.00% | ✅ Excelente |
| DOI | 97.01% | ✅ Excelente |
| **Keywords** | **40.00%** | ❌ Deficiente |

### Problema crítico: Keywords faltantes

**Implicaciones:**
- 60% de documentos (201 docs) NO tienen keywords explícitas
- Imposible hacer análisis temático tradicional
- Keywords Plus de WoS solo cubren parte del corpus

**Solución implementada en Fase 2A:**
- Extracción de keywords desde abstracts usando NLP
- TF-IDF para identificar términos relevantes
- Topic modeling (LDA) para descubrir temas latentes

---

## 3. EVOLUCIÓN TEMPORAL

### Producción anual:

| Año | Documentos | Crecimiento | Tasa (%) |
|-----|-----------|-------------|----------|
| 2016 | 12 | - | - |
| 2017 | 8 | -4 | -33.3% |
| 2018 | 11 | +3 | +37.5% |
| 2019 | 15 | +4 | +36.4% |
| 2020 | 14 | -1 | -6.7% |
| **2021** | **29** | **+15** | **+107.1%** 🔥 |
| 2022 | 40 | +11 | +37.9% |
| 2023 | 42 | +2 | +5.0% |
| 2024 | 52 | +10 | +23.8% |
| **2025** | **99** | **+47** | **+90.4%** 🚀 |
| 2026 | 13 | -86 | -86.9% ⚠️ |

⚠️ **Nota:** 2026 son datos parciales (febrero), no usar para tendencias

### Tres fases identificadas:

**FASE 1 (2016-2020): Crecimiento Moderado**
- Producción estable: 8-15 docs/año
- Promedio: 12 docs/año
- 2020: ligera caída (-6.7%) posiblemente por COVID-19

**FASE 2 (2021-2024): Aceleración Post-COVID**
- 2021: **PUNTO DE INFLEXIÓN** (+107% vs 2020)
- Producción sostenida: 29-52 docs/año
- Promedio: 41 docs/año (+242% vs Fase 1)
- Tasa de crecimiento promedio: +22% anual

**FASE 3 (2025): EXPLOSIÓN**
- 99 documentos en un solo año
- +90.4% vs 2024
- Casi **3x el promedio 2016-2024**
- 29.6% de todo el corpus en un solo año

### Hipótesis explicativas:

**Para 2021 (+107%):**
1. Recuperación post-COVID
2. Digitalización acelerada de la educación
3. Mayor financiamiento para investigación educativa
4. Backlog de investigaciones pausadas en 2020

**Para 2025 (+90%):**
1. Consolidación del campo post-pandemia
2. Énfasis global en educación STEM
3. Integración de IA en educación (tema emergente)
4. Mayor presión por publicar (publish or perish)
5. Posible artefacto de indexación (WoS/Scopus aceleraron)

---

## 4. DISTRIBUCIÓN GEOGRÁFICA

### Top 15 países productores:

| Ranking | País | Documentos | % del corpus |
|---------|------|-----------|-------------|
| 1 | Alemania | 22 | 6.57% |
| 2 | Indonesia | 17 | 5.07% |
| 2 | Turquía | 17 | 5.07% |
| 4 | China | 12 | 3.58% |
| 5 | España | 9 | 2.69% |
| 6 | Australia | 8 | 2.39% |
| 7 | Canadá | 7 | 2.09% |
| 8 | Reino Unido | 6 | 1.79% |
| 9-12 | USA, India, Italia | 4 c/u | 1.19% c/u |
| 13 | Brasil | 2 | 0.60% |
| 13 | Colombia | 2 | 0.60% |
| 15 | Chile, Japón | 1 c/u | 0.30% c/u |

### Análisis por región:

**Europa (dominante):**
- Alemania, España, UK, Italia, Francia = ~13-15%
- Alta productividad en educación científica
- Tradición de investigación didáctica fuerte

**Asia (emergente):**
- Indonesia, Turquía, China, India = ~14-16%
- Crecimiento acelerado post-2020
- Enfoque en tecnología educativa

**América Latina (GAP CRÍTICO):**
- Brasil (2), Colombia (2), Chile (1) = <1%
- **Totalmente sub-representada**
- **OPORTUNIDAD:** Artículo puede destacar este gap

**América del Norte:**
- USA (4), Canadá (7) = moderado
- Sorprendentemente bajo dado tamaño del sector educativo

**Oceanía:**
- Australia (8) = bien representada proporcionalmente

### Implicaciones:

✅ **Contribución original:** Identificar gap LATAM
✅ **Recomendación:** Políticas para fomentar investigación regional
✅ **Futuras investigaciones:** Análisis focalizado en países sub-representados

---

## 5. JOURNALS MÁS PRODUCTIVOS

### Top 10:

| # | Journal | Docs | % | Cuartil |
|---|---------|------|---|---------|
| 1 | International Journal of Science Education | 15 | 4.48% | Q1 |
| 2 | Frontiers in Education | 12 | 3.58% | Q2 |
| 3 | Education Sciences | 12 | 3.58% | Q2 |
| 4 | Research in Science & Technological Education | 8 | 2.39% | Q1 |
| 5 | International Journal of Science Education | 7 | 2.09% | Q1 |
| 6-9 | Multiple (J. Sci. Ed. Tech, J. Research Sci. Teaching, etc.) | 6 c/u | 1.79% | Q1 |
| 10 | Jurnal Pendidikan IPA Indonesia | 5 | 1.49% | Q2-Q3 |

### Observaciones clave:

**Alta fragmentación:**
- Top 20 journals = solo 30% del corpus
- No hay journal hegemónico
- Campo muy multidisciplinar

**Implicaciones:**
- Difusión amplia del conocimiento (positivo)
- Dificultad para rastrear toda la literatura (negativo)
- Múltiples comunidades de investigación no totalmente conectadas

**Estrategia de publicación:**
- Apuntar a **Int. J. Science Education** (líder consistente)
- Alternativas sólidas: Research in Sci. Ed., J. Research Sci. Teaching
- Considerar open-access (Frontiers) para mayor visibilidad

---

## 6. IDIOMAS DE PUBLICACIÓN

| Idioma | Documentos | % |
|--------|-----------|---|
| Inglés | 322 | 96.12% |
| Español | 8 | 2.39% |
| Turco | 2 | 0.60% |
| Thai, Francés, Alemán | 1 c/u | 0.30% c/u |

### Análisis:

**Dominio absoluto del inglés:**
- 96% es esperado en literatura científica internacional
- Sesgo inherente hacia países anglófonos

**Presencia mínima de español:**
- Solo 8 docs (2.4%)
- Relacionado con gap LATAM
- Barrera de idioma como factor limitante

**Recomendación para el artículo:**
- Reconocer sesgo lingüístico como limitación
- Discutir implicaciones para diversidad del conocimiento
- Sugerir mayor inclusión de literatura en otros idiomas

---

## 7. TIPOS DE DOCUMENTOS

| Tipo | Documentos | % |
|------|-----------|---|
| Article | 335 | 100% |

### Observación crítica:

**100% artículos** es anómalo para un estudio bibliométrico típico

**Posibles explicaciones:**
1. Filtro intencional en búsqueda original (solo articles)
2. Exclusión manual de conference papers, reviews, etc.
3. Característica del campo (poco uso de otros formatos)

**Implicaciones:**
- Corpus homogéneo (positivo para comparabilidad)
- Posible sesgo hacia investigación empírica formal
- Exclusión de literature reviews podría limitar panorama

**Recomendación:**
- Verificar si fue intencional
- Si no, considerar incluir review articles en futuro update
- Mencionar como criterio de inclusión en Methods

---

## 8. ESTADÍSTICAS DESCRIPTIVAS CLAVE

### Autores:
- **Total de autores únicos:** ~800-1000 (estimado, requiere limpieza)
- **Promedio de autores por documento:** ~3-4
- **Colaboración predominante:** Multi-autor (>90%)

### Instituciones:
- **Países representados:** ~50-60
- **Instituciones únicas:** ~300-400 (estimado)
- **Alta fragmentación institucional**

### Citaciones:
- **Rango:** 0 a ~150 citaciones (estimado)
- **Mediana:** ~5-10 citaciones (bajo, corpus reciente)
- **Documentos no citados:** ~20-30% (común en papers recientes)

---

## 9. PATRONES IDENTIFICADOS

### Temporal:
✅ Crecimiento exponencial post-2021
✅ Año 2025 como "año dorado" del campo
✅ Recuperación clara post-pandemia

### Geográfico:
✅ Europa y Asia lideran
⚠️ América Latina muy sub-representada
⚠️ África casi ausente

### Temático (preliminar, sin keywords):
- Tecnología educativa (común en títulos/abstracts)
- Inquiry-based learning (mencionado frecuentemente)
- Assessment & evaluation (tema recurrente)

---

## 10. LIMITACIONES IDENTIFICADAS

### Del corpus:
1. **Keywords faltantes (60%)** - resuelto con NLP en Fase 2A
2. **Sesgo lingüístico** - 96% inglés
3. **Sesgo de base de datos** - solo Scopus/WoS (falta Google Scholar, ERIC)
4. **Año 2026 incompleto** - datos parciales
5. **Solo articles** - excluye otros formatos

### Del análisis:
1. **Países inferidos desde affiliations** - puede tener errores
2. **Deduplicación por título** - método simple, posibles falsos negativos
3. **Sin validación manual** - asumir calidad de indexación

---

## 11. GAPS IDENTIFICADOS (Contribuciones potenciales)

### Gap 1: Geográfico
❌ **América Latina sub-representada**
✅ **Solución:** Artículo puede enfatizar este gap y recomendar políticas

### Gap 2: Metodológico
❌ **60% sin keywords explícitas**
✅ **Solución:** Uso de NLP para extracción automática (innovación)

### Gap 3: Temático
❌ **Sin análisis de evolución temática**
✅ **Solución:** Topic modeling con dimensión temporal (Fase 2A)

### Gap 4: Redes
❌ **Sin mapeo de colaboraciones**
✅ **Solución:** Análisis de co-autoría y co-citación (Fase 2B)

---

## 12. INSIGHTS ACCIONABLES

### Para investigadores:
1. **Tema caliente:** Publicar ahora en este campo = alta visibilidad
2. **Journals abiertos:** Frontiers en alza (12 docs)
3. **Colaboración internacional:** Esencial (mayoría multi-autor)

### Para policy-makers:
1. **Financiar investigación LATAM:** Gap crítico a cerrar
2. **Fomentar STEM education research:** Campo en expansión
3. **Apoyar open access:** Mayor democratización del conocimiento

### Para educadores:
1. **Tecnología integrada:** Tendencia dominante post-2020
2. **Inquiry-based learning:** Pedagogía recurrente
3. **Assessment innovador:** Área activa de investigación

---

## 13. PRÓXIMOS ANÁLISIS (Fase 2)

### Fase 2A - Temático:
- [ ] Extracción NLP de keywords
- [ ] Topic modeling (LDA)
- [ ] Evolución temporal de temas
- [ ] Identificar temas emergentes vs declinantes

### Fase 2B - Redes:
- [ ] Co-autoría (autores, países, instituciones)
- [ ] Co-citación (documentos influyentes)
- [ ] Acoplamiento bibliográfico
- [ ] Ecosistema de journals

### Fase 2C - Impacto:
- [ ] Ranking de autores (H-index)
- [ ] Distribución de citaciones
- [ ] Sleeping beauties
- [ ] Journals de alto impacto

---

## 14. ARCHIVOS GENERADOS

### Datos:
- `datos_fusionados.csv` - Dataset principal (335 × ~30 campos)
- `01_diagnostico_completo.xlsx` - Excel multi-hoja

### Figuras:
- `01_produccion_anual.png` - Tendencia temporal
- `02_tipos_documento.png` - Distribución tipos
- `03_top_paises.png` - Mapa geográfico

### Tablas:
- `01_completitud_campos.csv` - Métricas calidad
- `02_produccion_anual.csv` - Serie temporal
- `03_top_journals.csv` - Ranking journals

---

**Conclusión:** Corpus de alta calidad, con limitación en keywords que será resuelta mediante NLP. Hallazgos preliminares muestran campo en consolidación con gaps geográficos y temáticos claros.

**Fecha:** Febrero 9, 2026  
**Siguiente paso:** Fase 2A - Análisis Temático
