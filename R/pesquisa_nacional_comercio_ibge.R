### Pesquisa Mensal de Comércio | IBGE

library(tidyverse)


# Importação dos Dados ------------------------------------------------------------------------

# Dados Mensais Pesquisa Comércio IBGE, receita bruta
## Dados extraidos API - Tabela 3416 SIDRA
## Indice de **Receita**
## UF: MG/RJ/ES/SP


pmc_indice_uf_rob <- sidrar::get_sidra(
  api = "/t/3416/n3/31,32,33,35/v/565/p/all/c11046/40312,90668,90669/d/v565%201") %>%
  janitor::clean_names() %>%
  as_tibble()


pmc_indice_uf_rob <- pmc_indice_uf_rob %>%
  select(unidade_da_federacao, variavel, tipos_de_indice, mes_codigo, valor) %>%
  mutate(data = lubridate::ym(mes_codigo)) %>%
  select(-mes_codigo)


# Dados Mensais Pesquisa Comércio IBGE, volume
## Dados extraidos API - Tabela 3416 SIDRA
## Indice de **Receita**
## UF: MG/RJ/ES/SP

pmc_indice_uf_vol <- sidrar::get_sidra(
  api = "/t/3416/n3/31,32,33,35/v/564/p/all/c11046/40312,90668,90669/d/v564%201") %>%
  janitor::clean_names() %>%
  as_tibble()


pmc_indice_uf_vol <- pmc_indice_uf_vol %>%
  select(unidade_da_federacao, variavel, tipos_de_indice, mes_codigo, valor) %>%
  mutate(data = lubridate::ym(mes_codigo)) %>%
  select(-mes_codigo)


# Dados Mensais Pesquisa Comércio IBGE, receita bruta
## Dados extraidos API - Tabela 3418 SIDRA
## Indice de **Receita**
## Supermercados - Alimentação, bebidas e fumo
## UF: MG/RJ/ES/SP


pmc_sup_indice_uf_rob <- sidrar::get_sidra(
  api = "//t/3418/n3/31,32,33,35/v/565/p/all/c11046/40311,90668,90669/c85/90672/d/v565%201") %>%
  janitor::clean_names() %>%
  as_tibble()

pmc_sup_indice_uf_rob <- pmc_sup_indice_uf_rob %>%
  select(unidade_da_federacao, variavel, tipos_de_indice, mes_codigo, valor) %>%
  mutate(data = lubridate::ym(mes_codigo)) %>%
  select(-mes_codigo)



# Dados Mensais Pesquisa Comércio IBGE, volume
## Dados extraidos API - Tabela 3418 SIDRA
## Indice de **Volume**
## Supermercados - Alimentação, bebidas e fumo
## UF: MG/RJ/ES/SP


pmc_sup_indice_uf_vol <- sidrar::get_sidra(
  api = "/t/3418/n3/31,32,33,35/v/564/p/all/c11046/40311,90668,90669/c85/90672/d/v564%201") %>%
  janitor::clean_names() %>%
  as_tibble()

pmc_sup_indice_uf_vol <- pmc_sup_indice_uf_vol %>%
  select(unidade_da_federacao, variavel, tipos_de_indice, mes_codigo, valor) %>%
  mutate(data = lubridate::ym(mes_codigo)) %>%
  select(-mes_codigo)



# Gráficos  -----------------------------------------------------------------------------------

## Análise volume supermercados

pmc_sup_indice_uf_vol %>%
  filter(data >= "2019-01-01") %>%
  filter(tipos_de_indice == "Índice base fixa (2014=100)") %>%

  ggplot(aes(data, valor)) +
  geom_line()+
  facet_wrap(vars(unidade_da_federacao))+
  labs(title = "Índices de Volume | Pesquisa Mensal de Comércio | IBGE",
      subtitle = "Alimentos, bebidas e fumo em Supermercados"  ) +
  xlab("")+
  ylab("Índice (2014 = 100)")+
  theme_bw()


## Análise variacão

pmc_sup_indice_uf_vol %>%
  filter(data >= "2019-01-01") %>%
  filter(tipos_de_indice == "Variação mensal (base: igual mês do ano anterior)") %>%

  ggplot(aes(data, valor)) +
  geom_col()+
  facet_wrap(vars(unidade_da_federacao))+
  labs(title = "Índices de Volume | Pesquisa Mensal de Comércio | IBGE",
       subtitle = "Alimentos, bebidas e fumo em Supermercados"  ) +
  xlab("")+
  ylab("Variação mensal %(base: igual mês do ano anterior)")+
  theme_bw()

