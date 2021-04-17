Do portal [Sidra](https://sidra.ibge.gov.br/home/pms/brasil), do [IBGE](https://ibge.gov.br/), baixamos dados de saneamento básico, abastecimento de água, ocupação de domicílios e população total referentes ao Censo de 2010.

Para facilitar e melhor documentar a importação dos dados, baixamos os dados a partir da API do portal Sidra com o auxílio do pacote `sidrar`.

A página [http://api.sidra.ibge.gov.br/](http://api.sidra.ibge.gov.br/) pode (e deve) ser utilizada para buscar os parâmetros disponíveis de cada uma das tabelas.

O script em R utilizado para importação e limpeza dos dados pode ser encontrado [aqui](https://github.com/openvironment/ods6/blob/main/data-raw/ibge.R).

##### Esgotamento sanitário

Página: https://sidra.ibge.gov.br/tabela/1394

Variáveis de interesse:

- Código do município 
- Nome do município
- Número de domicílios permanentes ocupados servidos por fossa

##### Abastecimento

Página: https://sidra.ibge.gov.br/tabela/3217

Variáveis de interesse:

- Código do município 
- Nome do município
- Número de domicílios permanentes ocupados abastecidos por poço e mina, localizados na propriedade

##### População total

Páginas: https://sidra.ibge.gov.br/tabela/200

Variáveis de interesse:

- Código do município 
- Nome do município
- Número de municípios ocupados permanentes
- População Total
