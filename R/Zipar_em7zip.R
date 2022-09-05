#' Funcao para compactar arquivos .csv
#'
#' @param caminho_pasta caminho da pasta contendo os arquivos em formato .csv, que deverao ser compactados. O arquivo fica salvo na pasta de trabalho.
#'
#' @export


Zipar_em7zip <- function(caminho_pasta="atualizacao_csv"){

      Zipar_em7zip = function(sQualPasta)
      {
            sWDTava = getwd()
            setwd(dirname(sQualPasta))
            sQuem = gsub("[/]", "\\\\", sQualPasta)

            dirname(sQuem)
            NomeArquivo = paste0("eufaco7zip",".bat")
            sNomePasta7zip = basename(sQuem)
            sArquivoSaida = basename(sQuem)
            sQualPasta7zip = sQuem

            if(dir.exists("C:/Program Files/7-Zip/"))
            {
                  sTexto = "set PATH=%PATH%;C:\\Program Files\\7-Zip\\"
            }else if(dir.exists("C:/Program Files (x86)/7-Zip/"))
            {
                  sTexto = "set PATH=%PATH%;C:\\Program Files (x86)\\7-Zip\\"
            }else
            {
                  stop("Error, o 7zip not installed?")
            }


            sTexto2 = paste0("\npushd ",sQualPasta7zip)
            sTexto3 = paste0("\n7z a -r ../",sArquivoSaida," *")
            sTexto4 = '\n( del /q /f "%~f0" >nul 2>&1 & exit /b 0  )'

            cat(sTexto,file=NomeArquivo,append = TRUE)
            cat(sTexto2,file=NomeArquivo,append = TRUE)
            cat(sTexto3,file=NomeArquivo,append = TRUE)
            cat(sTexto4,file=NomeArquivo,append = TRUE)

            shell.exec(NomeArquivo)

            while(file.exists(NomeArquivo))
            {
                  Sys.sleep(10)
            }

            setwd(sWDTava)
            return(TRUE)
      }

      Zipar_em7zip(caminho_pasta)

}
