# global.R

library(shiny)
library(DT)
library(nlme)
library(ggplot2)
library(plotly)
library(shinythemes)

# Variables globales
valores_corta = c(0.77, 3.85, 7.7)
valores_media = c(1.1, 5.5, 11)
valores_larga = c(1.34, 6.7, 13.4)

df = read.csv("data/osilaciones.csv", sep = ";")

## Step 1

valores_map = list(
  Corto = valores_corta,
  Medio = valores_media,
  Largo = valores_larga
)

# Órdenes de oscilaciones que quieres evaluar
ordenes = c(1, 5, 10)

# Iterar sobre cada longitud de hilo y cada orden
for (hilo in names(valores_map)) {
  for (i in seq_along(ordenes)) {
    orden = ordenes[i]
    valor_ref = valores_map[[hilo]][i]
    
    df[(df$long_hilo == hilo) & (df$orden_oscilaciones == orden), "tiempo"] =
      abs(df[(df$long_hilo == hilo) & (df$orden_oscilaciones == orden), "tiempo"] - valor_ref) / valor_ref
  }
}


# Factorización
df$id = factor(df$id, levels = unique(df$id))
df$long_hilo = factor(df$long_hilo, levels = unique(df$long_hilo))
df$orden_oscilaciones = factor(df$orden_oscilaciones, levels = unique(df$orden_oscilaciones))
df$hora_realizar = factor(df$hora_realizar, levels = unique(df$hora_realizar))