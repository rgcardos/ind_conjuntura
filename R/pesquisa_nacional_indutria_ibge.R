## Pesquisa Mensal Indústria ##

library(tidyverse)


## Importação tabela IBGE 3653 - SIDRA

### Parâmetros selecionados:
### Variável : Todos os campos com variações percentuais
### Atividade: Seção 3.10 - Fabricação de Produtos Alimentícios
### Período: Todos
### UF: MG/SP/RJ/ES

api_sidra <- "/t/3653/n3/31,32,33,35/v/3139,3140,3141,4139/p/all/c544/129317/d/v3139%201,v3140%201,v3141%201,v4139%201"

pim_sidra <- sidrar::get_sidra(api = api_sidra) %>%
  janitor::clean_names() %>%
  as_tibble() %>%
  drop_na(valor) %>%
  select(data = mes_codigo, variavel, uf = unidade_da_federacao, valor)


pim_sidra %>%
  filter(uf == "Minas Gerais") %>%
  filter(data >= "2019-01-01") %>%
  ggplot(aes(data, valor))+
  geom_col()+
  facet_wrap(vars(variavel))
