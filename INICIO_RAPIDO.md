# ⚡ INICIO RÁPIDO - 5 PASOS PARA COMENZAR

## 🎯 Objetivo
Configurar tu entorno R y ejecutar el primer análisis bibliométrico en **menos de 15 minutos**.

---

## 📋 LISTA DE VERIFICACIÓN PREVIA

Antes de comenzar, asegúrate de tener:
- ✅ R instalado (versión 4.0+)
- ✅ RStudio instalado
- ✅ Proyecto `article_didacsci` abierto en RStudio
- ✅ Archivos descargados de este chat

---

## 🚀 5 PASOS PARA COMENZAR

### PASO 1: Organizar archivos (2 minutos)

#### 1.1 Crear estructura de carpetas
En la **consola de RStudio**, copia y pega esto:

```r
# Crear carpetas necesarias
dir.create("data/raw", recursive = TRUE, showWarnings = FALSE)
dir.create("outputs/figuras", recursive = TRUE, showWarnings = FALSE)
dir.create("outputs/tablas", recursive = TRUE, showWarnings = FALSE)
dir.create("scripts", showWarnings = FALSE)

# Verificar que se crearon
list.dirs(recursive = FALSE)
```

Deberías ver:
```
[1] "./data"
[2] "./outputs"
[3] "./scripts"
```

#### 1.2 Mover archivos .bib
**IMPORTANTE:** Copia manualmente estos 2 archivos:

Desde tu carpeta de descargas:
- `scopus_export_Feb_9-2026_4a282d97-49f3-4a6d-9084-05a1dd2ac18e.bib`
- `savedrecs.bib`

A la carpeta:
- `article_didacsci/data/raw/`

#### 1.3 Mover scripts descargados
Copia los scripts que descargaste de este chat a:
- `article_didacsci/scripts/`

---

### PASO 2: Instalar paquetes (5-10 minutos) ☕

#### 2.1 Abrir script de instalación
En RStudio:
1. File → Open File...
2. Navega a: `scripts/00_instalacion_paquetes.R`
3. Abre el archivo

#### 2.2 Ejecutar TODO el script
- Selecciona todo: **Ctrl+A** (Windows/Linux) o **Cmd+A** (Mac)
- Ejecuta: **Ctrl+Enter** (Windows/Linux) o **Cmd+Enter** (Mac)

#### 2.3 Esperar y observar
En la consola verás algo como:
```
📥 Instalando: bibliometrix
✅ bibliometrix instalado correctamente
📥 Instalando: tidyverse
✅ tidyverse instalado correctamente
...
```

**⏱️ TIEMPO ESTIMADO:** 5-10 minutos (perfecto para un café)

#### 2.4 Verificar resultado final
Al terminar verás:
```
🎉 ¡INSTALACIÓN COMPLETADA EXITOSAMENTE!
✅ Tu entorno R está listo para el análisis bibliométrico.
```

**Si ves errores:** No te preocupes, revisa la sección "PROBLEMAS COMUNES" abajo ⬇️

---

### PASO 3: Verificar instalación (1 minuto) 🧪

Copia y pega esto en la **consola de RStudio**:

```r
# Test rápido
library(bibliometrix)
library(tidyverse)
library(igraph)

cat("✅ Todos los paquetes críticos cargados correctamente\n")

# Verificar que los archivos .bib están en su lugar
file.exists("data/raw/scopus_export_Feb_9-2026_4a282d97-49f3-4a6d-9084-05a1dd2ac18e.bib")
file.exists("data/raw/savedrecs.bib")
```

**Resultado esperado:**
```
✅ Todos los paquetes críticos cargados correctamente
[1] TRUE
[1] TRUE
```

Si ves `FALSE`, los archivos .bib NO están en la ubicación correcta. Revisa el PASO 1.2 ⬆️

---

### PASO 4: Ejecutar primer análisis (2-3 minutos) 🎯

#### 4.1 Abrir script principal
1. File → Open File...
2. Navega a: `scripts/01_diagnostico_inicial_ACTUALIZADO.R`
3. Abre el archivo

#### 4.2 Ejecutar TODO el script
- Selecciona todo: **Ctrl+A** / **Cmd+A**
- Ejecuta: **Ctrl+Enter** / **Cmd+Enter**

#### 4.3 Observar progreso
Verás mensajes como:
```
📦 Instalando paquetes necesarios...
✅ Todos los paquetes cargados exitosamente

📖 Cargando archivos bibliográficos...
✅ Scopus cargado: 226 registros
✅ WoS cargado: 152 registros

🔄 Fusionando bases de datos...
✅ Duplicados eliminados: 43
...
```

---

### PASO 5: Revisar resultados (1-2 minutos) 📊

Cuando termine, verás:
```
✅ DIAGNÓSTICO INICIAL COMPLETADO
📁 Archivos generados en outputs/
```

#### Archivos generados:

Ve a la carpeta `outputs/` y encontrarás:

**📊 Figuras:**
- `outputs/figuras/01_produccion_anual.png`
- `outputs/figuras/02_tipos_documento.png`
- `outputs/figuras/03_top_paises.png`

**📋 Tablas:**
- `outputs/tablas/01_completitud_campos.csv`
- `outputs/tablas/02_top_journals.csv`

**💾 Datos:**
- `outputs/datos_fusionados.rds` (formato R)
- `outputs/datos_fusionados.csv` (formato universal)
- `outputs/01_diagnostico_completo.xlsx` (Excel con múltiples hojas)

---

## 🎉 ¡FELICITACIONES!

Si llegaste hasta aquí, ya completaste el diagnóstico inicial. 

### ¿Qué sigue?

Los próximos scripts que ejecutarás son:

1. **02A_analisis_tematico_nlp.R** - Topic modeling y keywords
2. **02B_analisis_redes.R** - Redes de colaboración y co-citación
3. **02C_analisis_impacto.R** - Análisis de citaciones y h-index
4. **03_figuras_finales_publicacion.R** - Generar todas las figuras finales

Cada script tomará ~5-10 minutos y generará visualizaciones avanzadas.

---

## 🐛 PROBLEMAS COMUNES Y SOLUCIONES

### ❌ Error: "cannot open file..."
**Causa:** Archivos .bib no están en `data/raw/`  
**Solución:** Vuelve al PASO 1.2 y copia los archivos

### ❌ Error: "there is no package called 'X'"
**Causa:** Paquete no se instaló correctamente  
**Solución:** Instálalo manualmente:
```r
install.packages("nombre_del_paquete")
```

### ❌ Error: "unable to access index for repository"
**Causa:** Problema de conexión a CRAN  
**Solución:**
```r
options(repos = c(CRAN = "https://cloud.r-project.org/"))
```

### ❌ Script se queda "pensando" mucho tiempo
**Causa:** Análisis computacionalmente intensivo (normal)  
**Solución:** **ESPERA** - Puede tomar 2-5 minutos. Observa si hay actividad en la consola.

### ❌ Errores de encoding (caracteres raros)
**Causa:** Caracteres especiales en los .bib  
**Solución:** Ya está manejado automáticamente en los scripts

### ⚠️ Advertencias (warnings)
**NO son errores.** Puedes ignorarlas si el script termina con "✅ COMPLETADO"

---

## 📞 ¿NECESITAS AYUDA?

Si encuentras un problema que no está aquí:

1. **Copia el mensaje de error completo**
2. **Anota qué paso estabas ejecutando**
3. **Pégalo en nuestro siguiente mensaje**

Te ayudaré a resolverlo.

---

## ✅ CHECKLIST FINAL

Marca cada item conforme lo completes:

- [ ] Carpetas creadas (`data/raw/`, `outputs/`, etc.)
- [ ] Archivos .bib copiados a `data/raw/`
- [ ] Scripts copiados a `scripts/`
- [ ] Paquetes instalados exitosamente
- [ ] Test de verificación pasado (todos TRUE)
- [ ] Primer análisis ejecutado sin errores
- [ ] Archivos generados en `outputs/`

---

**🎯 Si marcaste todos ✅, estás listo para los análisis avanzados**

**Tiempo total invertido:** ~15-20 minutos
**Próximo paso:** Ejecutar scripts de Fase 2 (análisis avanzados)

---

## 💡 TIPS PARA TRABAJAR MÁS EFICIENTE

### Atajos de teclado útiles:
- **Ctrl/Cmd + Enter:** Ejecutar línea o selección
- **Ctrl/Cmd + Shift + C:** Comentar/descomentar código
- **Ctrl/Cmd + L:** Limpiar consola
- **Alt + -:** Insertar operador de asignación `<-`

### Configuración recomendada:
```r
# Al inicio de cada sesión
options(scipen = 999)  # Desactivar notación científica
options(max.print = 100)  # Limitar output largo
```

---

**Última actualización:** Febrero 2026  
**Versión:** 1.0
