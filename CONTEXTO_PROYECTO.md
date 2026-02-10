# 📋 CONTEXTO DEL PROYECTO - RESUMEN EJECUTIVO

## 🎯 OBJETIVO
Producir un artículo bibliométrico Q1/Q2 sobre **didáctica de ciencias naturales y calidad educativa** (2016-2026).

---

## 📊 ESTADO ACTUAL

### ✅ COMPLETADO - Fase 1: Diagnóstico

**Corpus consolidado:**
- 335 documentos únicos
- Scopus (226) + Web of Science (152)
- 43 duplicados eliminados (11.38%)
- Periodo: 2016-2026
- Calidad: 100% completitud en campos críticos

**Archivos disponibles:**
```
outputs/
├── datos_fusionados.csv              # Dataset principal (335 docs)
├── 01_diagnostico_completo.xlsx      # Excel resumen
├── figuras/
│   ├── 01_produccion_anual.png       # Tendencia temporal
│   ├── 02_tipos_documento.png        
│   └── 03_top_paises.png             
└── tablas/
    ├── 01_completitud_campos.csv     
    ├── 02_produccion_anual.csv       
    └── 03_top_journals.csv           
```

---

## 🔥 HALLAZGOS CLAVE

1. **Explosión 2025:** 99 documentos (+90% vs 2024)
   - El campo está en **fase de consolidación**
   
2. **Punto de inflexión 2021:** +107% marca cambio post-pandemia

3. **Gap keywords:** Solo 40% tienen keywords explícitas
   - **Solución:** Extracción NLP desde abstracts

4. **Gap geográfico:** América Latina muy sub-representada
   - Colombia: 2 docs, Chile: 1 doc
   - **Oportunidad de nicho**

5. **Alta fragmentación de journals:** Sin revista dominante
   - Top 20 = solo 30% del corpus
   - Campo multidisciplinar

---

## 📋 PLAN DE TRABAJO

### 🔵 FASE 2A: Análisis Temático (NLP)
**Tiempo estimado:** 2-3 días

**Tareas:**
1. Preprocesamiento de abstracts (limpieza, tokenización, stemming)
2. TF-IDF y extracción de keywords
3. Topic Modeling con LDA (k=6-10 topics óptimos)
4. Visualizaciones:
   - Topics heatmap temporal
   - Alluvial diagram (evolución temas)
   - Word clouds por topic
   - Keywords co-occurrence network
   - Trend topics timeline

**Output:**
- 5 figuras temáticas
- Dataset con topics asignados
- Tabla de descripción de topics

---

### 🟢 FASE 2B: Análisis de Redes
**Tiempo estimado:** 2-3 días

**Tareas:**
1. Red de co-autoría (autores, países, instituciones)
2. Red de co-citación (documentos influyentes)
3. Acoplamiento bibliográfico (similaridad temática)
4. Red de journals (ecosistemas de citación)
5. Mapa de colaboración internacional

**Output:**
- 5 grafos de redes
- Tablas con métricas de centralidad
- Identificación de clusters/comunidades

---

### 🟡 FASE 2C: Análisis de Impacto
**Tiempo estimado:** 1-2 días

**Tareas:**
1. Métricas de autores (H-index, productividad, citaciones)
2. Distribución de citaciones (histogram, outliers)
3. Sleeping beauties (papers con citaciones tardías)
4. Journals de alto impacto (ranking, cuartiles)
5. Análisis temporal de citaciones

**Output:**
- 4 figuras de impacto
- Tablas de rankings (autores, journals, papers)

---

### 🔴 FASE 3: Figuras y Tablas Finales
**Tiempo estimado:** 2 días

**Tareas:**
1. Regenerar todas las figuras con specs de publicación
   - 300+ DPI, paletas colorblind-friendly
   - Formatos: PNG + PDF vectorial
2. Formatear todas las tablas estilo journal
   - CSV + DOCX + LaTeX
3. Crear archivo con especificaciones (para Methods)

**Output:**
- 12-15 figuras publication-ready
- 6-9 tablas formateadas
- Documentación metodológica

---

### 🟣 FASE 4: Manuscrito
**Tiempo estimado:** 3-5 días

**Estructura:**
1. **Introduction** - Background, research questions
2. **Methods** - Corpus, análisis, herramientas
3. **Results** - Estadísticas, temas, redes, impacto
4. **Discussion** - Interpretación, gaps, implicaciones
5. **Conclusions** - Resumen, futuras direcciones

**Output:**
- Draft en LaTeX/Word
- Referencias en BibTeX
- Materiales suplementarios

---

## 🎯 DECISIONES METODOLÓGICAS

✅ **Enfoque:** Análisis comprehensivo (temporal + temático + redes + impacto)
✅ **Visualización:** Gráficos ggplot2 personalizados (no bibliometrix estándar)
✅ **Keywords:** Extracción NLP desde abstracts (no solo keywords originales)
✅ **Corpus completo:** Sin filtros por citaciones (mantener 335 docs)
✅ **Todos los idiomas:** Pero identificar patrones por idioma

---

## 📌 PRIORIDADES PARA INNOVAR

### Visualizaciones no estándar:
- ✅ Alluvial/Sankey diagrams (evolución temática)
- ✅ Chord diagrams (relaciones entre journals/países)
- ✅ Heatmaps dinámicos (colaboración geográfica)
- ✅ Network graphs con clustering (co-autoría, co-citación)

### Análisis diferenciadores:
- ✅ Topic modeling validado (coherence scores)
- ✅ Extracción NLP de keywords (TF-IDF)
- ✅ Detección de "sleeping beauties"
- ✅ Análisis multi-dimensional integrado

### Gaps identificados (contribuciones originales):
- ✅ América Latina sub-representada → oportunidad
- ✅ Temas emergentes post-2021 → IA, tecnología educativa
- ✅ Colaboración internacional → clusters geográficos

---

## 🎓 JOURNALS TARGET

**Tier 1 (Q1):**
1. Journal of Research in Science Teaching (IF ~4.5)
2. International Journal of Science Education (IF ~3.5)
3. Science Education (IF ~3.8)

**Tier 2 (Q1/Q2):**
4. Research in Science Education (IF ~2.5)
5. International Journal of Science and Mathematics Education (IF ~2.5)

---

## 📂 ARCHIVOS CLAVE

**Para cargar al inicio:**
- `outputs/datos_fusionados.csv` - Dataset principal (335 registros)
- `outputs/01_diagnostico_completo.xlsx` - Estadísticas previas

**Documentación completa:**
- `ESTRATEGIA_COMPLETA.md` - Plan detallado de implementación
- `HALLAZGOS_FASE1.md` - Resultados diagnóstico inicial

---

## ⚠️ NOTAS IMPORTANTES

1. **Keywords faltantes (60%):** Extracción NLP es crítica
2. **Año 2026 incompleto:** Solo 13 docs, no usar para tendencias
3. **Idioma:** 96% inglés, 2.4% español, resto <1%
4. **Tipo documento:** 100% articles (verificar si intencional)

---

## 🚀 PRÓXIMO PASO INMEDIATO

**Ejecutar Fase 2A - Análisis Temático:**
1. Cargar `datos_fusionados.csv`
2. Preprocesar abstracts
3. Ejecutar LDA con k=6-10
4. Generar visualizaciones temáticas
5. Validar resultados con métricas de coherencia

---

**Fecha:** Febrero 9, 2026  
**Estado:** Listo para Fase 2A  
**Usuario:** Experiencia limitada en R, prefiere explicaciones claras
