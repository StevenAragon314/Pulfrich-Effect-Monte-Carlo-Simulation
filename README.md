# Pulfrich-Effect-Monte-Carlo-Simulation

El proyecto consiste en evaluar y garantizar la potencia estadística de un diseño experimental basado en la ilusión óptica del Efecto Pulfrich a través de un péndulo simple.
Dado que la recolección de datos experimentales es costosa en tiempo y recursos, el problema a resolver es determinar el tamaño de muestra mínimo necesario para detectar
diferencias significativas verdaderas (evitando Errores Tipo II) entre distintos tratamientos.

Para lograrlo, el sistema simula datos bajo diferentes escenarios de varianza y magnitudes de efecto ($\Delta$), modelando las dependencias complejas de las mediciones 
(diferentes longitudes de hilo y órdenes de oscilación) mediante Modelos Lineales Mixtos (LME) y Simulaciones de Monte Carlo, considerando el individuo/repetición como un efecto aleatorio (bloque).

# 🎯 Simulación de Potencia Estadística: Efecto Pulfrich (Péndulo Simple)

[![R](https://img.shields.io/badge/R-276DC3?style=for-the-badge&logo=r&logoColor=white)](https://www.r-project.org/)
[![Shiny](https://img.shields.io/badge/Shiny-000000?style=for-the-badge&logo=rstudio&logoColor=white)](https://shiny.rstudio.com/)

Este repositorio contiene una aplicación interactiva y una arquitectura de simulación para evaluar la **potencia estadística** de un diseño experimental basado en el Efecto Pulfrich. La herramienta permite optimizar el tamaño de la muestra y analizar la sensibilidad del experimento antes de la recolección masiva de datos empíricos.

## 📌 Descripción del Análisis

El diseño experimental evalúa los tiempos de oscilación bajo tres tratamientos específicos (Longitud del hilo: `Corto`, `Medio`, `Largo`) y múltiples órdenes de oscilación (`1`, `5`, `10`). Para capturar la complejidad de las medidas repetidas y aislar la variabilidad intrínseca, el análisis subyacente implementa:

- **Modelos Lineales Mixtos (LME):** Modelado de la varianza con efectos fijos (tratamientos) y efectos aleatorios (bloques/repeticiones) utilizando la librería `nlme`.
- **Simulación de Monte Carlo:** Generación de miles de escenarios bajo la inyección de distintos deltas ($\Delta$) y alteraciones de varianza para trazar las curvas de probabilidad de rechazo de la hipótesis nula ($H_0$).

## 🏗️ Arquitectura del Proyecto

El código base ha sido modularizado siguiendo las mejores prácticas de desarrollo en R Shiny para garantizar su escalabilidad y mantenibilidad en entornos de investigación:

```text
├── data/
│   └── data.Rdata         # Estos datos no están de manera pública. En caso de necesitarlos debe escribir 'stevenaragon314@gmail.com'
                           # Estos datos han sido recolectados por: Isaac Valle (UCR), Miguel Obregon (UCR) & Esteven Aragón (UCR).
├── R/
│   └── sim_functions.R         # Lógica Monte Carlo y LME
├── global.R                    # Carga de dependencias y preprocesamiento vectorizado
├── ui.R                        # Interfaz gráfica (Frontend) reactiva
├── server.R                    # Controlador de eventos e instanciación de simulaciones
└── app.R                       # Punto de entrada de la aplicación
