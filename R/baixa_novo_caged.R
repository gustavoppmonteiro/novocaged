#' Funcao para baixar, descomprimir e ler microdados do Novo Caged
#'
#' @param ano Ano dos arquivos que devem ser baixados. Nao e possivel baixar microdados de meses de anos distintos.
#' @param mes_inicial Mes cujos microdados vao ser baixados. No caso de baixar mais de um mes, esse argumento deve ser o mes mais distante.
#' @param mes_final Argumento opcional. No caso de baixar varios meses, se refere ao mes mais recente. Se for baixar apenas um mes o preenchimento e opcional.
#' @param caminho Caminho contendo nome da pasta e do arquivo em que os dados serao salvos. Deve terminar em ".parquet".
#' @param apaga7z Argumento logico. Se TRUE, apaga os arquivos intermeiarios - dos microdados baixados e descompactados em formato .txt. CUIDADO: na pratica, apaga TODOS os arquivos .7z que estiverem salvas na pasta de trabalho!
#'
#' @export
#'
#' @examples
#' # library(DieeseCAGED)
#' # EXEMPLO 1: julho/22
#' # baixa_novo_caged(7, ano=2022, caminho="atualizacao/caged_202207.parquet")
#'
#' # # para ler:
#' # caged_2021m7 <- arrow::read_parquet("atualizacao/caged_202207.parquet")
#' # # para salvar em csv
#' # salva_parquet_em_csv(caminho_parquet="atualizacao/caged_202207.parquet",
#' #                      caminho_csv="atualizacao_csv/caged_202207.csv")
#' # # para zipar a pasta com csv
#' # Zipar_em7zip("atualizacao_csv")



baixa_novo_caged <- function(ano,
                             mes_inicial,
                             mes_final = mes_inicial,
                             caminho = "atualizacao/caged_atualizacao.parquet",
                             apaga7z = T) {

      # Referência ao pipe
      `%>%` <- magrittr::`%>%`


      baixa_caged(ano, mes_inicial, mes_final)
      Sys.sleep(2)

      descomprime_bases()
      Sys.sleep(2)

      salva_bases(ano, mes_inicial, mes_final, caminho)


      # apaga arquivos baixados -----------------------------------------------
      if(apaga7z==T){
            lista_7z <- list.files(pattern = ".7z")
            file.remove(lista_7z)
      }

      # apaga PastaMes
      unlink("PastaMes", recursive = T)

}


