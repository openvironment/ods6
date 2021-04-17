O [SEADE](https://www.seade.gov.br/) é o portal de estatísticas do Estado de São Paulo. É uma fundação vinculada à Secretaria de Governo, com o objetivo de produzir e disseminar análises e estatísticas socioeconômicas e demográficas.

Os dados estão disponibilizados [neste portal](http://produtos.seade.gov.br/produtos/projpop/index.php). Foi possível fazer o download completo da base a partir deste link: [http://produtos.seade.gov.br/produtos/projpop/download/Projpop.zip](http://produtos.seade.gov.br/produtos/projpop/download/Projpop.zip). O dicionário de variáveis pode ser baixado diretamente a partir do link [http://produtos.seade.gov.br/produtos/projpop/download/Dicionario.zip](http://produtos.seade.gov.br/produtos/projpop/download/Dicionario.zip).

Buscamos as seguintes variáveis:

- Código do município
- Ano
- Projeção População Total 
- Projeção do número de domicílios permanentes ocupados (anos 2011 a 2017)

O script em R utilizado para importação e limpeza dos dados pode ser encontrado [aqui](https://github.com/openvironment/ods6/blob/main/data-raw/seade.R).