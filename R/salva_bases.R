#' Funcao para baixar microdados do Novo Caged
#'
#' @param ano Ano dos arquivos que devem ser baixados. Nao e possivel baixar microdados de meses de anos distintos.
#' @param mes_inicial Mes cujos microdados vao ser baixados. No caso de baixar mais de um mes, esse argumento deve ser o mes mais distante.
#' @param mes_final Argumento opcional. No caso de baixar varios meses, se refere ao mes mais recente. Se for baixar apenas um mes o preenchimento e opcional.
#' @param caminho Caminho contendo nome da pasta e do arquivo em que os dados serao salvos. Deve terminar em ".parquet".
#'
#' @export


salva_bases <- function(ano,
                        mes_inicial,
                        mes_final=mes_inicial,
                        caminho="atualizacao/caged_atualizacao.parquet"){

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
      dir.create("atualizacao", showWarnings = FALSE)
      arrow::write_parquet(caged, caminho)


}


