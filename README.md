
# novocaged

<!-- badges: start -->
<!-- badges: end -->

O objetivo do novocaged é facilitar o download e armazenamento dos microdados
mensais do Novo Caged, disponibilizados no servidor do [PDET](ftp://ftp.mtps.gov.br/pdet/microdados/NOVO CAGED/).

A cada mês, ficam disponíveis dados de três tipos com as movimentações declaradas 
naquele mês - movimentações, fora do prazo e exclusões. 
As funções deste pacote baixam e empilham esses três arquivos.

A função `baixa_novo_caged` baixa todos os arquivos de um ou vários meses de um mesmo ano
(de uma só vez), descompacta os arquivos baixados e os salva em formato .parquet. 
O resultado final é um único arquivo em formato .parquet com todos os dados 
de todos os meses requisitados.

Também é possível rodar essas três tarefas separadamente.
Nesse caso, os arquivos baixados (zipados em 7-zip) e os arquivos descompactados (em formato .txt) ficam disponíveis na pasta de trabalho.

A função `salva_parquet_em_csv` mudam o formato dos arquivos de .parquet para .csv.

A função `Zipar_em7zip` compacta os arquivos .csv. em uma única pasta compactada.

A função `deflator_inpc` baixa a série histórica do INPC e cria as variáveis deflator e salario_real.

É fortemente recomendável que todos os argumentos das funções deste pacote 
sejam preenchidos da maneira mais extensa, explícita e correta, mesmo que isso pareça redundante.
Por exemplo, não há mensagens de erro de preenchimento. Mas é importante que o mes inicial seja menor do que o final e que ambos tenham valores entre 1 e 12.

OBS. 1: NÃO FUNCIONA PARA OS MESES ENTRE JANEIRO E MARÇO DE 2020!
OBS. 2: PARA USAR A FUNÇÃO baixa_novo_caged OU baixa_caged TEM QUE TER BAIXADO O 7Z: https://www.7-zip.org/download.html



## Instalação

Você pode instalar a versão em desenvolvimento do novocaged a partir do [GitHub](https://github.com/) usando:

``` r
# install.packages("devtools")
devtools::install_github("gustavoppmonteiro/novocaged")
```

## Exemplo


Abaixo, alguns exemplos de como usar o pacote:

``` r
library(novocaged)
## exemplo básico


# Exemplo 1: baixa_novo_caged ---------------------------------------------

# baixa dados de jan-fev/2022, descompacta e salva arquivo com nome de 
# "cagedJanFev22", em uma pasta chamada "atualizacao"
novocaged::baixa_novo_caged(ano = 2022,
                              mes_inicial = 1,
                              mes_final = 2,
                              nome_pasta="atualizacao",
                              nome_arquivo = "cagedJanFev22")

# le arquivo salvo
dados_JanFev22 <- arrow::read_parquet("atualizacao/cagedJanFev22.parquet")


# calcula salario real (com valores de fev/22)
dados_JanFev22 <- dados_JanFev22 %>% 
      deflator_inpc(., mes_base="202202")
      
      
# acrescenta duas variaveis: salario_minimo e salario_minimo_necessario
dados_JanFev22 <- dados_JanFev22 %>% 
      SM_DIEESE()



# Exemplo 2: em 3 etapas --------------------------------------------------

# baixa dados de mar-abr/2022, descompacta e salva um arquivo com dados divulgados
# em março, com o nome de "cagedMar22", numa pasta chamada "atualizacao"
novocaged::baixa_caged(ano = 2022,
                         mes_inicial = 3,
                         mes_final = 4)
                         
novocaged::descomprime_bases()

novocaged::salva_bases(ano = 2022,
                         mes_inicial = 3,
                         mes_final = 3,
                         nome_pasta="atualizacao",
                         nome_arquivo = "cagedMar22")

# le arquivo salvo
dados_Mar22 <- arrow::read_parquet("atualizacao/cagedMar22.parquet")



# Transforma .parquet em .csv e depois zipa -------------------------------

# muda formato do arquivo "cagedJanFev22.parquet" para .csv e salva na pasta "atualizacao_csv"
novocaged::salva_parquet_em_csv(caminho_parquet = "atualizacao/cagedJanFev22.parquet",
                                  caminho_csv = "atualizacao_csv/cagedJanFev22.csv")

# compacta todos os arquivos que estiverem na pasta "atualizacao_csv"
novocaged::Zipar_em7zip(caminho_pasta = "atualizacao_csv")




# EXEMPLO 3: TABELAS ------------------------------------------------------

# 1) faz tabela de frequencia de movimentacao em marco/2022, segundo sexo e regiao
T1 <- dados_Mar22 %>%
        filter(competenciamov==202203) %>% 
        novocaged::faz_freq_mov(sexo, regiao)

T1


# 2) faz tabela com media de salario em marco/2022, segundo sexo e regiao
T2 <- dados_Mar22 %>%
        filter(competenciamov==202203) %>% 
        novocaged::faz_media(., 
                             var_media = salario, 
                             sexo, regiao,
                             tira_outliers = T) # tira acima de 150SM e abaixo de 0,3SM
        
T2


```

