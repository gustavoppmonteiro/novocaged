
# baixa_caged <- function(ano,
#                         mes_inicial,
#                         mes_final=mes_inicial){
#       
#       # Referência ao pipe
#       `%>%` <- magrittr::`%>%`
#       
#       # meses
#       meses <- sprintf("%02d", c(mes_inicial:mes_final))
#       
#       # Baixa os microdados
#       for (i in seq_along(meses)) {
#             
#             # exclusoes
#             origem = paste0("ftp://ftp.mtps.gov.br/pdet/microdados/NOVO CAGED/",
#                             ano,
#                             "/",
#                             ano,
#                             meses[i],
#                             "/CAGEDEXC",
#                             ano,
#                             meses[i],
#                             ".7z")
#             destino = paste0("CAGEDEXC",
#                              ano,
#                              meses[i],".7z")
#             
#             result <- tryCatch(
#                   {
#                         curl::curl_download(url = origem, destfile = destino, mode = "wb")
#                   },
#                   error = function(e) {
#                         utils::download.file(url = origem, destfile = destino, mode = "wb")
#                         NULL
#                   }
#             )
#             
#             
#             # fora do prazo
#             origem = paste0("ftp://ftp.mtps.gov.br/pdet/microdados/NOVO CAGED/",
#                             ano,
#                             "/",
#                             ano,
#                             meses[i],
#                             "/CAGEDFOR",
#                             ano,
#                             meses[i],
#                             ".7z")
#             destino = paste0("CAGEDFOR",
#                              ano,
#                              meses[i],".7z")
#             
#             result <- tryCatch(
#                   {
#                         curl::curl_download(url = origem, destfile = destino, mode = "wb")
#                   },
#                   error = function(e) {
#                         utils::download.file(url = origem, destfile = destino, mode = "wb")
#                         NULL
#                   }
#             )
#             
#             
#             # movimentacao
#             origem = paste0("ftp://ftp.mtps.gov.br/pdet/microdados/NOVO CAGED/",
#                             ano,
#                             "/",
#                             ano,
#                             meses[i],
#                             "/CAGEDMOV",
#                             ano,
#                             meses[i],
#                             ".7z")
#             destino = paste0("CAGEDMOV",
#                              ano,
#                              meses[i],".7z")
#             
#             result <- tryCatch(
#                   {
#                         curl::curl_download(url = origem, destfile = destino, mode = "wb")
#                   },
#                   error = function(e) {
#                         utils::download.file(url = origem, destfile = destino, mode = "wb")
#                         NULL
#                   }
#             )
#             
#       }
#       
# }
# 
# #TODO: tem que fazer excecoes para janeiro a março de 2020. Ver "D:\Dados\Bases de dados\novo caged\atualizacao_2020.R".
# 
# install.packages("devtools")
devtools::install_github("gustavoppmonteiro/novocaged")

novocaged::baixa_novo_caged(ano = 2022,
                            mes_inicial = 10,
                            caminho="atualizacao/cagedOut22.parquet")

dados_out <- arrow::read_parquet("atualizacao/cagedOut22.parquet")
