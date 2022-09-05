#' Funcao para transformar arquivos .parquet em arquivos .csv
#'
#' @param caminho_parquet caminho do arquivo em formato .parquet.
#' @param caminho_csv caminho em que o arquivo no formato .csv deve ser salvo.
#'
#' @export


salva_parquet_em_csv <- function(caminho_parquet="atualizacao/caged_atualizacao.parquet",
                                 caminho_csv="atualizacao_csv/caged_atualizacao.csv"){

      # cria pasta atualizacao_csv (se ja nao existir)
      dir.create("atualizacao_csv", showWarnings = FALSE)

      # le arquivo em parquet
      arquivo <- arrow::read_parquet(caminho_parquet)

      # transforma em csv
      arrow::write_csv_arrow(arquivo, caminho_csv)

      rm(arquivo)
}
