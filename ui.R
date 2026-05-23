# ui

ui = tagList(
    shinythemes::themeSelector(),
    navbarPage(
      "Simluación de Diferencias Medias",
      # Primera vetnana de introducción
      tabPanel("Introducción",
               mainPanel(
                 tabsetPanel(
                   # Primera sub venta
                   tabPanel("Resumen del Estudio",
                            withMathJax(),
                            helpText('and a fact about \\(\\pi\\):
           $$H_0: \\mu_{11} = \\mu_{21} \\text{    }   H_1: \\mu_{11}  < \\mu_{21}$$
          $$H_0: \\mu_{11}  = \\mu_{31} \\text{    }  H_1: \\mu_{11}  < \\mu_{31}$$'),
                            numericInput("num_df_creado", label = h3("Ingresa el número de observaciones: "), value = 18), 
                            DTOutput("data_frame_creado"),
                            DTOutput("data_frame_creado2"),
                            
                   ) # Termina primera sub ventana
                   ,
                   # Segunda sub ventana
                   tabPanel("Descriptivo de los Datos Obtenidos",
                            checkboxGroupInput("resumen_datos", label = h3("Resumen dentro de cada tratamiento"), 
                                               choices = list("Gráfico de acordión" = 1, "Tabla resumen de varianzas" = 2, "Tabla resumen de medias" = 3),
                                               selected = 3),
                            
                            conditionalPanel(
                              condition = "input.resumen_datos == 1",
                              plotlyOutput("acordeonPlot")
                              ),
                            
                            conditionalPanel(
                              condition = "input.resumen_datos == 3",
                            tabPanel("Medias verdaderas",
                                     DTOutput("tabla_mean"),
                            )
                            ),
                            conditionalPanel(
                              condition = "input.resumen_datos == 2",
                              DTOutput("tabla_var")
                            ),
                            
                            ) # Termina segunda sub ventana
                   ,
                   # Tercera sub ventana
                   tabPanel("Gráfico de las medias", 
                            sliderInput("medias_verdaderas_slyder", label = h3("Slider Range"), min = 0, 
                                       max = 1, value = c(0.1, 0.3)),
                            plotlyOutput("medias_verdaderas")
                            )
                   # Termina rercera sub ventana
                 )
               )
      ) # Inicia segunda ventana
      ,
      tabPanel("Presentación", 
               tags$iframe(src = "https://drive.google.com/file/d/1FjpxTUrqwuZZK7n-0bTUVm2zZgJCrZ8z/view?usp=sharing", 
                           width = "100%", 
                           height = "600px"))
      # Finaliza segunda ventana
      ,
      tabPanel("Simulación", 
           sidebarLayout(
             sidebarPanel(
               sliderInput("delta",
                           "Delta:",
                           min = 0.01,
                           max = 1,
                           value = 0.1),
               numericInput("N", "Numero de repeticiones:", value = 100),
               numericInput("muestrainicio", "Numero de muestra inicio:", value = 30),
               numericInput("muestrafinal", "Numero de muestra final:", value = 36),
               numericInput("cambiar_var", "Cambio de varianza", 0.003873),
               width = 3  
             ),
             
             mainPanel(
               fluidRow(
                 column(12, plotlyOutput("plotpotencia1", height = "300px")),
                 column(12, plotlyOutput("plotpotencia2", height = "300px")),
                 column(12, plotlyOutput("plotpotencia3", height = "300px"))
               ),
               width = 9
             )
           )
  )
      # Fianaliza tercer ventana
    )
  )