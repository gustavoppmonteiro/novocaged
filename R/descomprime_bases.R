#' Funcao para descompactar os arquivos baixados (que vao para uma pasta chamada PastaMes)
#'
#' @export
#'
#' @examples
#' novocaged::descomprime_bases()


descomprime_bases <- function(){

      # Referência ao pipe
      `%>%` <- magrittr::`%>%`
      
      # Lista arquivos que começam com "CAGED"
      arquivos_caged <- list.files(pattern = "^CAGED", full.names = TRUE)
      
      # Verifica se existem arquivos correspondentes
      if (length(arquivos_caged) == 0) {
            stop("Erro: Nenhum arquivo que começa com 'CAGED' foi encontrado.")
      }
      
      # Verificar se o 7-Zip está instalado em uma das pastas padrão
      if (dir.exists("C:/Program Files/7-Zip/")) {
            unlink("./PastaMes", recursive = TRUE)
            Sys.sleep(2)
            for (arquivo in arquivos_caged) {
                  system(paste0("\"C:/Program Files/7-Zip/7z\" e -oPastaMes ", shQuote(arquivo)))
            }
            Sys.sleep(2)
      } else if (dir.exists("C:/Program Files (x86)/7-Zip/")) {
            unlink("./PastaMes", recursive = TRUE)
            Sys.sleep(2)
            for (arquivo in arquivos_caged) {
                  system(paste0("\"C:/Program Files (x86)/7-Zip/7z\" e -oPastaMes ", shQuote(arquivo)))
            }
            Sys.sleep(2)
      } else {
            stop("Erro: 7zip não instalado?")
      }
}


