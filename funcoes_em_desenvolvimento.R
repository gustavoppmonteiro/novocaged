#' Funcao para baixar e arrumar em formato de tabela a serie historica de salarios minimos e salario minimos necessarios calculados pelo DIEESE
#'
#' @export


SM_DIEESE <- function() {
      
      # Referência ao pipe
      `%>%` <- magrittr::`%>%`
      
      # library(tidyverse)
      # library(lubridate)
      # library(rvest)
      
      url <- "https://www.dieese.org.br/analisecestabasica/salarioMinimo.html"
      
      data_frame <- rvest::read_html(url) %>% 
            rvest::html_table() %>% 
            .[[1]] %>% 
            dplyr::as_tibble()
      
      data_frame$salario_minimo <- gsub("R\\$", "", data_frame$`Salário mínimo nominal`)
      data_frame$salario_minimo_necessario <- gsub("R\\$", "", data_frame$`Salário mínimo necessário`)
      
      
      data_frame$Período <- (gsub("Janeiro", "1", data_frame$Período))
      data_frame$Período <- (gsub("Fevereiro", "2", data_frame$Período))
      data_frame$Período <- (gsub("Março", "3", data_frame$Período))
      data_frame$Período <- (gsub("Abril", "4", data_frame$Período))
      data_frame$Período <- (gsub("Maio", "5", data_frame$Período))
      data_frame$Período <- (gsub("Junho", "6", data_frame$Período))
      data_frame$Período <- (gsub("Julho", "7", data_frame$Período))
      data_frame$Período <- (gsub("Agosto", "8", data_frame$Período))
      data_frame$Período <- (gsub("Setembro", "9", data_frame$Período))
      data_frame$Período <- (gsub("Outubro", "10", data_frame$Período))
      data_frame$Período <- (gsub("Novembro", "11", data_frame$Período))
      data_frame$Período <- (gsub("Dezembro", "12", data_frame$Período))
      
      
      data_frame2 <- data_frame %>% 
            dplyr::filter(as.numeric(Período)<=12) %>%  
            dplyr::mutate(num_linha = row_number()) %>% 
            dplyr::arrange(desc(num_linha))
      
      create_date_column <- function(n_rows){
              
              data <- seq(as.Date("1994-07-01"), 
                          by = "month", 
                          length.out = n_rows,
                          format = "%Y%m")
      
              return(data)
      }
      
      
      coluna_datas <- create_date_column(nrow(data_frame2))
      
      data_frame2$competenciamov <- lubridate::strftime(coluna_datas, format = "%Y%m")
      
      
      data_frame2 <- data_frame2 %>% 
            dplyr::select(competenciamov, salario_minimo, salario_minimo_necessario)
      
      return(data_frame2)

}



#' Funcao para fazer tabelas de frequencia de admissoes e desligamentos no Novo Caged. 
#'
#' @param dados nome da base de dados do novo caged. Necessario que contenha as variaveis: saldomovimentacao e indicadordeexclusao
#' @param ... uma ou mais variaveis que se deseja cruzar 
#'
#' @export


faz_freq_mov <- function(dados, ...) {
      
      # Referência ao pipe
      `%>%` <- magrittr::`%>%`
        
        tabela <- dados %>%
                dplyr::group_by(saldomovimentacao, ...) %>%
                
                dplyr::summarise(estat_fdp = sum(saldomovimentacao[is.na(indicadordeexclusao)]),
                                 exclusao = sum(saldomovimentacao[!is.na(indicadordeexclusao)])) %>%
                
                # tira exclusões dos desligamentos
                dplyr::mutate(movimentacao = estat_fdp - exclusao) %>%
                dplyr::mutate(nome_mov = ifelse(saldomovimentacao == 1, "adm", "desl")) %>% 
                
                dplyr::ungroup() %>% 
                
                dplyr::select(-saldomovimentacao, -estat_fdp, -exclusao)
        
        return(tabela)
        
}



#' Funcao para fazer tabelas de médias no Novo Caged. 
#'
#' @param dados nome da base de dados do novo caged. Necessario que contenha as variaveis: saldomovimentacao e indicadordeexclusao
#' @param ... uma ou mais variaveis que se deseja cruzar 
#' @param var_media variavel que se deseja tirar media. P. ex.: salario. No default, calcula o salario real com base no INPC do ultimo mes que aparece na base do Caged
#' @param tira_outliers tira salarios minimos abaixo de 0,3SM e acima de 150SM?
#' @export

faz_media <- function(dados, ..., var_media=salario_real, tira_outliers=T) {
        
        if (tira_outliers==T) {
              
              lista_salario_minimo <- novocaged::SM_DIEESE()
                
                dados <- dados %>% 
                      merge(., lista_salario_minimo, by = "competenciamov") %>% 
                      dplyr::filter(salario>=0.3*salario_minimo & salario<=150*salario_minimo)
        }
        
        
        if (length(dados$salario_real)==0) {
                
                dados <- dados %>% 
                        novocaged::deflator_inpc()
                
        }
        
        T_massa <- dados %>%
                
                # tabela, com coluna estatistico + fora do prazo e coluna exclusao
                dplyr::group_by(...) %>%
                
                dplyr::summarise(adm_estat_fdp = sum({{var_media}}[is.na(indicadordeexclusao) & saldomovimentacao==1], na.rm = T),
                                 adm_exclusao = sum({{var_media}}[!is.na(indicadordeexclusao) & saldomovimentacao==1], na.rm = T),
                                 
                                 desl_estat_fdp = sum({{var_media}}[is.na(indicadordeexclusao) & saldomovimentacao==-1], na.rm = T),
                                 desl_exclusao = sum({{var_media}}[!is.na(indicadordeexclusao) & saldomovimentacao==-1], na.rm = T)) %>%
                
                # tira exclusões
                dplyr::mutate(adm_massa = adm_estat_fdp - adm_exclusao,
                              desl_massa = desl_estat_fdp - desl_exclusao,
                              .keep="unused")  %>% 
                
                dplyr::ungroup() %>% 
                tidyr::complete(...) %>% 
                dplyr::arrange(...) # essa parte tem que fazer pra que inclua linhas zeradas e nao da problema no cbind
        
        
        T_qde <- dados %>%
                
                # tabela, com coluna estatistico + fora do prazo e coluna exclusao
                dplyr::group_by(...) %>%
                
                dplyr::summarise(adm_estat_fdp = sum(saldomovimentacao[is.na(indicadordeexclusao) & saldomovimentacao==1]),
                                 adm_exclusao = sum(saldomovimentacao[!is.na(indicadordeexclusao) & saldomovimentacao==1]),
                                 
                                 desl_estat_fdp = sum(saldomovimentacao[is.na(indicadordeexclusao) & saldomovimentacao==-1]),
                                 desl_exclusao = sum(saldomovimentacao[!is.na(indicadordeexclusao) & saldomovimentacao==-1])) %>%
                
                # tira exclusões
                dplyr::mutate(adm_qde = adm_estat_fdp - adm_exclusao,
                              desl_qde = desl_estat_fdp - desl_exclusao,
                              .keep="unused")  %>% 
                
                dplyr::ungroup() %>% 
                tidyr::complete(...) %>% 
                dplyr::arrange(...) %>% # essa parte tem que fazer pra que inclua linhas zeradas e nao da problema no cbind
                
                select(adm_qde, desl_qde)
        
        
        T_media <- cbind(T_massa, T_qde) %>% 
                dplyr::mutate(adm = adm_massa/adm_qde,
                              desl = desl_massa/-desl_qde,
                              .keep = "unused")
        
        return(T_media)
        
}


