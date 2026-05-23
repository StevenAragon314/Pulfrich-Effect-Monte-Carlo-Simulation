# server.R

server = function(input, output) {

  datos = reactive({
      potencia(input$N, input$muestrainicio, input$muestrafinal, input$delta)
    })
    
    output$plotpotencia1 = renderPlotly({

      data = datos()
    
      plot_ly(
        x = data[, 5],
        y = data[, 1],
        type = 'scatter',
        mode = 'lines+markers',
        name = 'MedioCorto',
        line = list(color = 'blue'),
        marker = list(color = 'blue')
      ) %>%
        add_trace(
          y = data[, 2],
          name = 'LargoCorto',
          line = list(color = 'red'),
          marker = list(color = 'red')
        ) %>%
        layout(
          xaxis = list(title = 'Tamaños de muestra'),
          yaxis = list(title = 'Potencia'),
          title = 'Potencia para la detección de diferencias del experimento del péndulo simple',
          legend = list(x = 0.5, y = -0.2, orientation = 'h')
        )
    })
    
    output$plotpotencia2 = renderPlotly({
      # Extraer los datos
      data = datos()
      
      # Crear el gráfico con plotly
      plot_ly(
        x = data[, 5],
        y = data[, 3],
        type = 'scatter',
        mode = 'lines',
        line = list(color = 'blue'),
        name = 'Encontrar ambas'
      ) %>%
        layout(
          title = 'Encontrar ambas',
          xaxis = list(title = 'Tamaño de Muestra'),
          yaxis = list(title = 'Probabilidad')
        )
    })
    
    output$plotpotencia3 = renderPlotly({
      # Extraer los datos
      data = datos()
      
      # Crear el gráfico con plotly
      plot_ly(
        x = data[, 5],
        y = data[, 4],
        type = 'scatter',
        mode = 'lines',
        line = list(color = 'green'),
        name = 'Encontrar alguna diferencia'
      ) %>%
        layout(
          title = 'Encontrar alguna diferencia',
          xaxis = list(title = 'Tamaño de Muestra'),
          yaxis = list(title = 'Probabilidad')
        )
    })
    
    output$tabla_mean = renderDT({
      df_descriptivo = as.data.frame(round(tapply(df$tiempo, list(df$long_hilo, df$orden_oscilaciones), mean), 4))
      datatable(df_descriptivo)
    })
    output$tabla_var = renderDT({
      df_descriptivo = as.data.frame(round(tapply(df$tiempo, list(df$long_hilo, df$orden_oscilaciones), var), 4))
      datatable(df_descriptivo)
    })
    
    mod = lm(df$tiempo ~ df$id)
    pre = predict(mod)
    t1 = df$tiempo - pre + mean(df$tiempo)
    df$t1 = t1
    
    output$acordeonPlot = renderPlotly({
      p1 = ggplot(df, aes(x = factor(orden_oscilaciones), y = t1, fill = factor(long_hilo))) +
        geom_violin(trim = FALSE) +
        theme_minimal() +
        labs(title = "Figura 01: Distribción de los errores por tratamiento", x = "Orden de Oscilaciones", y = "Tiempo Ajustado", fill = "Longitud del Hilo",
             subtitle = "Nota: Los datos observados han sido centrados") +
        scale_fill_brewer(palette = "Set3")
      
      ggplotly(p1)
    })
    
    output$medias_verdaderas = renderPlotly({
      p2 = ggplot(df, aes(x = factor(orden_oscilaciones), y = tiempo, color = factor(long_hilo))) +
        stat_summary(fun = mean, geom = "point", size = 3) +
        theme_minimal() +
        labs(title = "Puntos de Media por Tratamiento", x = "Orden de Oscilaciones", y = "Tiempo", color = "Longitud del Hilo") +
        scale_color_manual(values = c("Corto" = "orange", "Medio" = "purple", "Largo" = "green")) +
        coord_cartesian(ylim = c(input$medias_verdaderas_slyder[1], input$medias_verdaderas_slyder[2]))
      
      ggplotly(p2)
    })
    
    getting_data = function(n = 30, mu1 = 2, delta = 0.1, var_ = 0.03413) {
      bloque = factor( rep(1:n, 3))
      
      long_hilo = rep(factor(rep(c('Corto','Medio','Largo'),each=n/3)),3)
      orden_oscilaciones = factor(rep(1:3, each=n))
      
      
      tratamiento=factor(rep(1:9,each=n/3))
      mu1 = 0.15
      muj = rep( rep(c(mu1+delta,mu1, mu1,mu1,mu1,mu1,mu1,mu1,mu1), each=n/3),1)
      
      
      s = sqrt(var_)
      n1 = n * 3
      Y1 = rnorm(n1, muj, s)#original
      
      eb = rnorm(n, 0, sqrt(3))
      efb = rep(eb, 3)
      efb
      Y =  Y1 + efb 
      a = data.frame(tratamiento,long_hilo,orden_oscilaciones,bloque,Y)
      return(as.data.frame(cbind(bloque, long_hilo, orden_oscilaciones, Y)))
      
    }
    output$data_frame_creado = renderDT({
      head(getting_data(n = input$num_df_creado), 10)
    })
    
    output$data_frame_creado2 = renderDT({
      tail(getting_data(n = input$num_df_creado), 10)
}