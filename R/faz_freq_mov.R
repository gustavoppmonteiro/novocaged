#' Funcao para fazer tabelas de frequencia de admissoes e desligamentos no Novo Caged. 
#'
#' @param dados nome da base de dados do novo caged. Necessario que contenha as variaveis: saldomovimentacao e indicadordeexclusao
#' @param ... uma ou mais variaveis que se deseja cruzar (p. ex.: competenciamov)
#' @param complete transforma missings implicitos em valores explicitos.
#'
#' @export


faz_freq_mov <- function(dados, ..., complete=T) {
      
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
      
      if(complete==T){
            tabela <- tabela %>% 
                  tidyr::complete(nome_mov, ...) %>% 
                  dplyr::mutate(movimentacao = ifelse(is.na(movimentacao), 0, movimentacao))
      }
      
      return(tabela)
      
}
