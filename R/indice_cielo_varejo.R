## Indice Cielo

library(tidyverse)

# Dowload dos dados ---------------------------------------------------------------------------

## Link para planilha atualizada deve ser obtido em:
## https://ri.cielo.com.br/informacoes-financeiras/indice-cielo-do-varejo-ampliado-icva/


link <- "https://apicatalog.mziq.com/filemanager/v2/d/4d1ebe73-b068-4443-992a-3d72d573238c/3e864198-0b72-c970-1771-80cd8c338a30?origin=2"

download.file(link, destfile = "data-raw/cielo.xlsx")

dados <- readxl::read_excel(path = "data-raw/cielo.xlsx") %>%
  janitor::clean_names() %>%
  rename(data = x) %>%
  mutate(data = lubridate::as_date(data)) %>%
  pivot_longer(cols = starts_with("icva"), names_to = "indice", values_to = "valor")


dados %>%
  filter(indice =="icva_nominal_c_ajuste_calendario") %>%
  filter(data >= "2020-01-01") %>%

  ggplot(aes(data, valor))+
  geom_col(fill = "gray50")+
  ggtitle(label = "Índice Cielo do Varejo Ampliado",
          subtitle = "% de Crescimento da Receita Nominal")+
  xlab("")+
  ylab("Variação (mês x mês do ano anterior)")+
  scale_y_continuous(labels = scales::label_percent(accuracy = 1))+
  scale_x_date(date_breaks = "2 months", date_labels = "%m/%Y")+
  theme_bw()
