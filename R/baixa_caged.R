#' Funcao para baixar microdados do Novo Caged
#'
#' @param ano Ano dos arquivos que devem ser baixados. Nao e possivel baixar microdados de meses de anos distintos.
#' @param mes_inicial Mes cujos microdados vao ser baixados. No caso de baixar mais de um mes, esse argumento deve ser o mes mais distante.
#' @param mes_final Argumento opcional. No caso de baixar varios meses, se refere ao mes mais recente. Se for baixar apenas um mes o preenchimento e opcional.
#'
#' @export

baixa_caged <- function(ano,
                        mes_inicial,
                        mes_final=mes_inicial){

      # Referência ao pipe
      `%>%` <- magrittr::`%>%`

      # meses
      meses <- sprintf("%02d", c(mes_inicial:mes_final))

      # Baixa os microdados
      for (i in seq_along(meses)) {

            # exclusoes
            origem = paste0("ftp://ftp.mtps.gov.br/pdet/microdados/NOVO CAGED/",
                            ano,
                            "/",
                            ano,
                            meses[i],
                            "/CAGEDEXC",
                            ano,
                            meses[i],
                            ".7z")
            destino = paste0("CAGEDEXC",
                             ano,
                             meses[i],".7z")

            utils::download.file(url = origem, destfile = destino, mode = "wb")


            # fora do prazo
            origem = paste0("ftp://ftp.mtps.gov.br/pdet/microdados/NOVO CAGED/",
                            ano,
                            "/",
                            ano,
                            meses[i],
                            "/CAGEDFOR",
                            ano,
                            meses[i],
                            ".7z")
            destino = paste0("CAGEDFOR",
                             ano,
                             meses[i],".7z")

            utils::download.file(url = origem, destfile = destino, mode = "wb")


            # movimentacao
            origem = paste0("ftp://ftp.mtps.gov.br/pdet/microdados/NOVO CAGED/",
                            ano,
                            "/",
                            ano,
                            meses[i],
                            "/CAGEDMOV",
                            ano,
                            meses[i],
                            ".7z")
            destino = paste0("CAGEDMOV",
                             ano,
                             meses[i],".7z")

            utils::download.file(url = origem, destfile = destino, mode = "wb")

      }

}

#TODO: tem que fazer excecoes para janeiro a março de 2020. Ver "D:\Dados\Bases de dados\novo caged\atualizacao_2020.R".
