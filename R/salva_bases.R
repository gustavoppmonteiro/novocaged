#' Funcao para salvar os microdados baixados e descompacados (em formato .txt) do Novo Caged
#'
#' @param ano Ano dos arquivos que devem ser baixados. Nao e possivel baixar microdados de meses de anos distintos.
#' @param mes_inicial Mes cujos microdados vao ser baixados. No caso de baixar mais de um mes, esse argumento deve ser o mes mais distante.
#' @param mes_final Argumento opcional. No caso de baixar varios meses, se refere ao mes mais recente. Se for baixar apenas um mes o preenchimento e opcional.
#' @param nome_pasta Caminho contendo nome da pasta em que o arquivo vai ser salvo.
#' @param nome_arquivo Nome do arquivo em que os dados serao salvos. Sera salvo em extensao .parquet. (Nao precisa colocar .parquet no nome)
#' @export


salva_bases <- function(ano,
                        mes_inicial,
                        mes_final=mes_inicial,
                        nome_pasta = "atualizacao",
                        nome_arquivo = "caged_atualizacao"){
      
      #TODO: tem que arrumar o caminho pra ser so o caminho mesmo, sem nome do arquivo
      #TODO: acho que tem que acrescentar um argumento so para o nome do arquivo
      
      # Referência ao pipe
      `%>%` <- magrittr::`%>%`
      
      # meses
      meses <- sprintf("%02d", c(mes_inicial:mes_final))
      
      
      caged <- data.frame()
      
      # Baixa os microdados
      for (i in seq_along(meses)) {
            
            # movimentacao
            mov <- utils::read.delim2(paste0("PastaMes/CAGEDMOV",
                                             ano,
                                             meses[i],
                                             ".txt"),
                                      sep = ";",
                                      encoding = "UTF-8")
            
            mov <- mov %>%
                  janitor::clean_names() %>%
                  dplyr::mutate(competenciaexc = NA,
                                indicadordeexclusao = NA)
            
            caged <-  rbind(caged, mov)
            
            
            # fora do prazo
            mov <- utils::read.delim2(paste0("PastaMes/CAGEDFOR",
                                             ano,
                                             meses[i],
                                             ".txt"),
                                      sep = ";",
                                      encoding = "UTF-8")
            
            mov <- mov %>%
                  janitor::clean_names() %>%
                  dplyr::mutate(competenciaexc = NA,
                                indicadordeexclusao = NA)
            
            caged <-  rbind(caged, mov)
            
            
            # exclusao
            mov <- utils::read.delim2(paste0("PastaMes/CAGEDEXC",
                                             ano,
                                             meses[i],
                                             ".txt"),
                                      sep = ";",
                                      encoding = "UTF-8")
            
            mov <- mov %>%
                  janitor::clean_names()
            
            caged <-  rbind(caged, mov)
            
      }
      
      
      
      # exporta ---------------------------------------------------------------
      # cria pasta atualizacao (se ja nao existir)
      dir.create(nome_pasta, showWarnings = FALSE)
      arrow::write_parquet(caged, paste0(nome_pasta, "/", nome_arquivo, ".parquet"))
      
      #TODO: tem que arrumar para que a pasta seja criada no caminho (mas tem que arrumar o caminho la em cima)
      
}

#TODO: tem que fazer excecoes para janeiro a março de 2020. Ver "D:\Dados\Bases de dados\novo caged\atualizacao_2020.R".
