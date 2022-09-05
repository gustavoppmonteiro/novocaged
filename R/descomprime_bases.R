#' Funcao para descompactar os arquivos baixados (que vao para uma pasta chamada PastaMes)
#'
#' @export
#'
#' @examples
#' novocaged::descomprime_bases()


descomprime_bases <- function(){

      # Referência ao pipe
      `%>%` <- magrittr::`%>%`

      # Descompactando na PastaMes
      if(dir.exists("C:/Program Files/7-Zip/")){

            unlink("./PastaMes", recursive=TRUE)
            Sys.sleep(2)

            system('"C:/Program Files/7-Zip/7z" e -oPastaMes CAGED*')
            Sys.sleep(2)

      }else if(dir.exists("C:/Program Files (x86)/7-Zip/")){

            unlink("./PastaMes", recursive=TRUE)
            Sys.sleep(2)

            system('"C:/Program Files (x86)/7-Zip/" e -oPastaMes CAGED*')
            Sys.sleep(2)

      }else{
            stop("Erro: 7zip nao instalado?")
      }

}



