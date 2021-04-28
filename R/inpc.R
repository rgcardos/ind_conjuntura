## Análise INPC

## Importação tabela SIDRA 7063 para cereais

library(tidyverse)


api_sidra <- "/t/7063/n7/3101,3301,3501,3201/v/44,68,2292/p/all/c315/7173,7175,7176,7188,7190,7195,7221,7359,12222,47617,107611/d/v44%202,v68%202,v2292%202"

inpc <- sidrar::get_sidra(api = api_sidra) %>%
  janitor::clean_names() %>%
  as_tibble()



inpc <- inpc %>%
  select(data = mes_codigo,
         produto = geral_grupo_subgrupo_item_e_subitem,
         cidade = regiao_metropolitana,
         variavel,
         valor) %>%
  mutate(data = lubridate::ym(data)) %>%
  mutate(produto = stringr::str_extract(produto, "[:UPPER:].+")) %>%
  mutate(cidade = stringr::str_remove(cidade, "[:blank:]\\([:upper:]{2}\\)")) %>%
  mutate(produto = stringr::str_remove(produto, "[:blank:]-")) %>%
  mutate(produto = stringr::str_squish(produto)) %>%
  mutate(produto = stringr::str_squish(produto)) %>%
  drop_na(valor)




