#' Funcao para fazer tabelas de médias no Novo Caged. 
#'
#' @param dados nome da base de dados do novo caged. Necessario que contenha as variaveis: saldomovimentacao e indicadordeexclusao
#' @param ... uma ou mais variaveis que se deseja cruzar 
#' @param var_media variavel que se deseja tirar media. P. ex.: salario. No default, calcula o salario real com base no INPC do ultimo mes que aparece na base do Caged
#' @param tira_outliers tira salarios minimos abaixo de 0,3SM e acima de 150SM? Obs.: funciona somente se estiver com acesso a Internet!
#' @param tira_intermitente tira intermitentes do calculo de salario medio
#' @export

faz_media <- function(dados, ..., var_media=salario_real, tira_outliers=T, tira_intermitente=T) {
      
      # Referência ao pipe
      `%>%` <- magrittr::`%>%`
      
      
      # tira os intermitentes
      if (tira_intermitente==T) {
            
            dados <- dados %>% 
                  dplyr::filter(indtrabintermitente == 0)
            
      }
      
      
      # tira os outliers
      if (tira_outliers==T) {
            
            # baixa os valores do SM
            lista_salario_minimo <- novocaged::SM_DIEESE()
            
            # junta a coluna de SM e filtra os outliers
            dados <- dados %>% 
                  merge(., lista_salario_minimo, by = "competenciamov") %>% 
                  dplyr::filter(salario>=0.3*salario_minimo & salario<=150*salario_minimo)
            
      }
      
      
      # deflaciona
      if (length(dados$salario_real)==0) {
            
            dados <- dados %>% 
                  novocaged::deflator_inpc()
            
      }
      
      # calcula a massa de salarios
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
      
      
      # calcula o total de mocimentacoes
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
      
      
      # faz a media
      T_media <- cbind(T_massa, T_qde) %>% 
            dplyr::mutate(adm = adm_massa/adm_qde,
                          desl = desl_massa/-desl_qde,
                          .keep = "unused")
      
      return(T_media)
      
}


