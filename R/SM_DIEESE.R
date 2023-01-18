#' Funcao para baixar e arrumar em formato de tabela a serie historica de salarios minimos e salario minimos necessarios calculados pelo DIEESE
#'
#' @export

SM_DIEESE <- function() {
      
      # Referência ao pipe
      `%>%` <- magrittr::`%>%`
      
      # baixa os dados
      url <- "https://www.dieese.org.br/analisecestabasica/salarioMinimo.html"
      
      data_frame <- rvest::read_html(url) %>% 
            rvest::html_table() %>% 
            .[[1]] %>% 
            dplyr::as_tibble()
      
      
      # arruma os nomes das variaveis
      data_frame$salario_minimo <- gsub("R\\$", "", data_frame$`Salário mínimo nominal`)
      data_frame$salario_minimo_necessario <- gsub("R\\$", "", data_frame$`Salário mínimo necessário`)
      
      
      # arruma coluna dos meses para numerica
      data_frame$`Período` <- (gsub("Janeiro", "1", data_frame$`Período`))
      data_frame$`Período` <- (gsub("Fevereiro", "2", data_frame$`Período`))
      data_frame$`Período` <- (gsub("Março", "3", data_frame$`Período`))
      data_frame$`Período` <- (gsub("Abril", "4", data_frame$`Período`))
      data_frame$`Período` <- (gsub("Maio", "5", data_frame$`Período`))
      data_frame$`Período` <- (gsub("Junho", "6", data_frame$`Período`))
      data_frame$`Período` <- (gsub("Julho", "7", data_frame$`Período`))
      data_frame$`Período` <- (gsub("Agosto", "8", data_frame$`Período`))
      data_frame$`Período` <- (gsub("Setembro", "9", data_frame$`Período`))
      data_frame$`Período` <- (gsub("Outubro", "10", data_frame$`Período`))
      data_frame$`Período` <- (gsub("Novembro", "11", data_frame$`Período`))
      data_frame$`Período` <- (gsub("Dezembro", "12", data_frame$`Período`))
      
      
      # coloca em ordem e tira linhas so com anos
      data_frame <- data_frame %>% 
            dplyr::filter(as.numeric(`Período`)<=12) %>%  
            dplyr::mutate(num_linha = dplyr::row_number()) %>% 
            dplyr::arrange(desc(num_linha))
      
      
      # funcao para criar coluna com as datas
      create_date_column <- function(n_rows){
            
            data <- seq(as.Date("1994-07-01"), 
                        by = "month", 
                        length.out = n_rows,
                        format = "%Y%m")
            
            return(data)
      }
      
      # cria coluna com as datas e junta a base
      coluna_datas <- create_date_column(nrow(data_frame))
      
      data_frame$competenciamov <- strftime(coluna_datas, format = "%Y%m")
      
      
      # deixa so as colunas de data e SM
      data_frame <- data_frame %>% 
            dplyr::select(competenciamov, salario_minimo, salario_minimo_necessario)
      
      
      # arruma as colunas de SM para numerica
      data_frame$salario_minimo <- as.numeric(gsub(",", ".", gsub("\\.", "", data_frame$salario_minimo)))
      data_frame$salario_minimo_necessario <- as.numeric(gsub(",", ".", gsub("\\.", "", data_frame$salario_minimo_necessario)))

      return(data_frame)
      
}

