#' Funcao para deflacionar salarios a partir do INPC(IBGE)
#'
#' @param base_caged  Base de dados do caged. A funcao cria duas variaveis: `deflator`, com o numero-indice mensal do INPC e `salario_real` com o valor deflacionado calculado.
#' @param mes_base Mes base para o calculo do deflator. Ex.: se for 202201, o deflator traz os salarios para valores de janeiro de 2022. Se nulo, calcula o deflator com base no mes mais recente do caged.
#'
#' @export


deflator_inpc <- function(base_caged,
                          mes_base=NULL){

      # Referência ao pipe
      `%>%` <- magrittr::`%>%`

      # ultimo mes do caged
      mes_max <- max(base_caged$competenciamov)

      # baixando inpc
      inpc <- sidrar::get_sidra(api = "/t/1736/n1/all/v/2289/p/all/d/v2289%2013") %>%
            dplyr::select(c("Mês (Código)", "Valor" )) %>%
            dplyr::mutate(competenciamov = `Mês (Código)`,
                          .keep="unused") %>%
            dplyr::filter(competenciamov<=mes_max) %>% # pega so meses que estao no caged
            dplyr::arrange(dplyr::desc(competenciamov))


      # escolhe mes_base
      if(is.null(mes_base)){

            valor_mes_base <- inpc$Valor[1]

      }else{

            valor_mes_base <- inpc %>%
                  dplyr::filter(competenciamov==mes_base)
            valor_mes_base <- valor_mes_base$Valor[1]

      }


      # cria deflator
      inpc <- inpc %>%
            dplyr::mutate(deflator = valor_mes_base/Valor,
                          .keep="unused")

      # junta inpc com caged
      base_caged <- base_caged %>%
            merge(., inpc, by="competenciamov")

      # calcula salario real
      base_caged <- base_caged %>%
            dplyr::mutate(salario_real = salario*deflator)
      
      #TODO: tem que colocar um 'return(base_caged)' aqui?
      return(base_caged)
      
}



