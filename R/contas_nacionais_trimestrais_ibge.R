#### Conjuntura Econômica ####
#### Contas Nacionais Trimestrais | PIB

library(tidyverse)


# Importação dos dados IBGE | Sidra -----------------------------------------------------------


## Importação dos dados com ajuste sazonal, tabela 1621 do SIDRA

pib_indice_aj_sa <- sidrar::get_sidra(x = 1621, period = "all") %>%
  janitor::clean_names() %>%
  as_tibble()

pib_indice_aj_sa <- pib_indice_aj_sa %>%
  select(trimestre_codigo, setores_e_subsetores_codigo, setores_e_subsetores, valor) %>%
  mutate(trimestre = lubridate::yq(trimestre_codigo)) %>%
  mutate(trimestre = lubridate::ceiling_date(trimestre, unit = "quarter")-1) %>%
  select(trimestre, setores_e_subsetores, valor)


## Importação dados sem ajuste sazonal, tabela 1620 do SIDRA

pib_indice <- sidrar::get_sidra(x = 1620, period = "all") %>%
  janitor::clean_names() %>%
  as_tibble()

pib_indice <- pib_indice %>%
  select(trimestre_codigo, setores_e_subsetores_codigo, setores_e_subsetores, valor) %>%
  mutate(trimestre = lubridate::yq(trimestre_codigo)) %>%
  mutate(trimestre = lubridate::ceiling_date(trimestre, unit = "quarter")-1) %>%
  select(trimestre, setores_e_subsetores, valor)


## Importação variação dados trimestrais

pib_var_trim <- sidrar::get_sidra(x = 5932, period = "all") %>%
  janitor::clean_names() %>%
  as_tibble()

pib_var_trim <- pib_var_trim %>%
  select(trimestre_codigo, setores_e_subsetores_codigo, setores_e_subsetores, valor, variavel) %>%
  mutate(trimestre = lubridate::yq(trimestre_codigo)) %>%
  mutate(trimestre = lubridate::ceiling_date(trimestre, unit = "quarter")-1) %>%
  select(trimestre, setores_e_subsetores, variavel, valor)


## Cria base de dados anual, tendo como referência o último triestre com informações
## disponibilizadas pelo IBGE. O que comparamos nesta base são as variações anuais
## do mais recente trimestre divulgado pelo IBGE

pib_indice_anual <- pib_indice %>%
  filter(
    lubridate::month(trimestre) == lubridate::month(max(pib_indice$trimestre))
    )




# Gráficos | Série Encadeada | Evolução PIB em número Índice  ---------------------------------


## Gráfico de evolução trimestral do índice PIB
## Para comparação de trimestres, usar a seérie com ajuste sazonal

pib_indice_aj_sa %>%
  filter(setores_e_subsetores == "PIB a preços de mercado") %>%

  ggplot(aes(trimestre, valor))+
  geom_line(size = 0.8)+
  geom_point(size = 1, alpha = 0.5)+
  ggtitle(label = "PIB a preços de mercado com ajuste sazonal",
          subtitle = "Série Encadeadada do Índice do Volume Trimestral")+
  xlab("Trimestre")+
  ylab("Número Índice")+
  scale_x_date(date_breaks = "1 year",
               date_minor_breaks = "3 month",
               labels = scales::date_format("%Y"))+
  theme_bw()


## Gráfico de evolução anual do índice PIB

pib_indice_anual %>%
  filter(setores_e_subsetores == "PIB a preços de mercado") %>%

  ggplot(aes(trimestre, valor))+
  geom_line(size = 0.8)+
  geom_point(size = 1, alpha = 0.5)+
  ggtitle(label = "PIB a preços de mercado sem ajuste sazonal",
          subtitle = "Série Encadeadada do Índice do Volume Anual")+
  xlab("Ano")+
  ylab("Número Índice")+
  scale_x_date(date_breaks = "1 year",
               labels = scales::date_format("%Y"))+
  theme_bw()


## Gráfico de evolução anual do índice PIB para Agro, Ind e Serviços


pib_indice_anual %>%
  filter(str_ends(setores_e_subsetores, "total")) %>%
  mutate(setores_e_subsetores = case_when(
    setores_e_subsetores == "Agropecuária - total" ~ "Agropecuária",
    setores_e_subsetores == "Indústria - total" ~ "Indústria",
    setores_e_subsetores == "Serviços - total" ~ "Serviços"
  )) %>%

  ggplot(aes(trimestre, valor))+
  geom_line(size = 0.8)+
  ggtitle(label = "PIB a preços de mercado sem ajuste sazonal",
          subtitle = "Série Encadeadada do Índice do Volume Anual")+
  xlab("Ano")+
  ylab("Número Índice")+
  scale_x_date(date_breaks = "5 year",
               labels = scales::date_format("%Y"))+
  facet_wrap(vars(setores_e_subsetores))+
  theme_bw()


# Gráficos | Variação Trimestal PIB -----------------------------------------------------------


## Variação trimestral

pib_var_trim %>%
  filter(setores_e_subsetores == "PIB a preços de mercado") %>%

  ggplot(aes(trimestre, valor))+
  geom_col()+
  facet_wrap(vars(variavel))+
  ggtitle(label = "Variação Trimestral PIB")+
  xlab("Trimestre")+
  ylab("% Variação")+
  theme_bw()



