% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/deflator_inpc.R
\name{deflator_inpc}
\alias{deflator_inpc}
\title{Funcao para deflacionar salarios do Caged a partir do INPC(IBGE)}
\usage{
deflator_inpc(base_caged, mes_base = NULL)
}
\arguments{
\item{base_caged}{Base de dados do caged. A funcao cria duas variaveis: \code{deflator}, com o numero-indice mensal do INPC e \code{salario_real} com o valor deflacionado calculado.}

\item{mes_base}{Mes base para o calculo do deflator. Ex.: se for 202201, o deflator traz os salarios para valores de janeiro de 2022. Se nulo, calcula o deflator com base no mes mais recente do caged.}
}
\description{
Funcao para deflacionar salarios do Caged a partir do INPC(IBGE)
}
