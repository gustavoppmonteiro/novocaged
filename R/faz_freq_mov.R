#' Funcao para fazer tabelas de frequencia de admissoes e desligamentos no Novo Caged. 
#'
#' @param dados nome da base de dados do novo caged. Necessario que contenha as variaveis: saldomovimentacao e indicadordeexclusao
#' @param ... uma ou mais variaveis que se deseja cruzar (p. ex.: competenciamov)
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
