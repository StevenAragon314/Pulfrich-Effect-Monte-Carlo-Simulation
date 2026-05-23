# R/sim_functions.R

calcular_p_valores_lme = function(n, delta, var_ = 0.03443796) {
  options(contrasts = c("contr.sum", "contr.poly"))
  
  bloque = factor(rep(1:n, 3))
  long_hilo = rep(factor(rep(c('Corto', 'Medio', 'Largo'), each = n/3)), 3)
  orden_oscilaciones = factor(rep(1:3, each = n))
  tratamiento = factor(rep(1:9, each = n/3))
  
  mu1 = 0.15
  muj = rep(rep(c(mu1 + delta, mu1, mu1, mu1, mu1, mu1, mu1, mu1, mu1), each = n/3), 1)
  
  s = sqrt(var_)
  n1 = n * 3
  Y1 = rnorm(n1, muj, s) 
  
  eb = rnorm(n, 0, sqrt(3))
  efb = rep(eb, 3)
  Y = Y1 + efb 
  
  a = data.frame(tratamiento, long_hilo, orden_oscilaciones, bloque, efb, muj, Y)
  mod_testing = lme(Y ~ long_hilo * orden_oscilaciones, random = ~1|bloque, data = a)
  
  Medio1=c(1,0,1,1,0,0,1,0,0)
  Corto1=c(1,1,0,1,0,1,0,0,0)
  Largo1=c(1,-1,-1,1,0,-1,-1,0,0)
 
  MC1 = Medio1-Corto1
  LC1 = Largo1-Corto1

    h = cbind(MC1,LC1)
    coef = mod_testing$coefficients$fixed

    L=t(h)%*%coef
    var=diag(t(h)%*%vcov(mod_testing)%*%h)

    ee=sqrt(var)
    t=abs(L)/ee

    p=pt(t,(n-3),lower.tail = F)

  return(list(value_15.45 = p[1], value_30.45 = p[2]))
}

simular_potencia = function(N, n_muestra_inicio, n_muestra_final, delta, var_input) {
  muestras = seq(n_muestra_inicio, n_muestra_final, by = 3)
      lista_matrices = vector("list", length(muestras))
      potenciaMCLCambas = numeric(length(muestras))
      potenciaMCLCalguna = numeric(length(muestras))
      
      for (num_muestras in 1:length(muestras)) {
        matrix = matrix(nrow = N, ncol = 2)
        
        for (i in 1:N) {
          result = calcular_p_valores_lme(muestras[num_muestras], delta, var_ = input$cambiar_var)
          matrix[i, ] = c(result$value_15.45, result$value_30.45)
        }
        
        lista_matrices[[num_muestras]] = matrix
      } 
      
      potenciaMCLC = matrix(nrow = length(lista_matrices), ncol = 2)
      
      for (i in 1:length(lista_matrices)) {
        matrix_actual = lista_matrices[[i]] 
        
        potenciaMCLC[i, 1] = mean(matrix_actual[, 1] < (0.05 / 3 * 2))
        potenciaMCLC[i, 2] = mean(matrix_actual[, 2] < (0.05 / 3 * 2))
        potenciaMCLCambas[i] = mean(matrix_actual[, 1] < (0.05 / 3) & matrix_actual[, 2] < (0.05 / 3))
        potenciaMCLCalguna[i] = mean(matrix_actual[, 1] < (0.05 / 3) | matrix_actual[, 2] < (0.05 / 3))
      }  
      
      return(cbind(potenciaMCLC, potenciaMCLCambas, potenciaMCLCalguna, muestras))
}

generar_datos_muestra = function(n = 30, mu1 = 2, delta = 0.1, var_ = 0.03413) {
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