O [Sistema Nacional de Informações Sobre Saneamento (SNIS)](http://www.snis.gov.br/) possui bases de dados com informações e indicadores sobre a prestação de serviços de Água e Esgotos, Manejo de Resíduos Sólidos Urbanos e Drenagem e Manejo das Águas Pluviais Urbanas.

No portal [http://app4.mdr.gov.br/serieHistorica](http://app4.mdr.gov.br/serieHistorica), buscamos as bases com as seguintes variáveis:

- Código do prestador
- Nome do Prestador
- Natureza jurídica do prestador
- AG002  - quantidade de ligações ativas de água
- AG004 - quantidade de ligações ativas de água micromedidas
- AG008 - volume de água micromedido
- AG010 - volume de água consumido
- AG012 - volume de água macromedido
- AG013 - quantidade de economias residenciais ativas de água
- AG014 - quantidade de economias ativas micromedidas
- ES006 - volume de esgoto tratado
- ES008 - quantidade de economias residenciais ativas de esgoto
- FN001 - receita operacional direta total
- FN002 - receita operacional direta de água
- FN015 - despesas de exploração (DEX)
- AG011 - volume de água faturado
- AG018 - volume de água tratada importado
- AG019 - volume de água faturado exportado

Para isso, fizemos a seguinte busca no portal:

**1.** No menu Água e Esgoto, selecionamos a opção **Informações e indicadores desagregados**. 

**2.** Nos filtros, utilizamos:

- Ano de referência: todos
- Abrangência: todos
- Tipo de serviço: todos
- Natureza jurídica: todos
- Região: sudeste
- Estado: São Paulo
- Prestadores por município: todos (676 selecionados)
    
**3.** Nas colunas, selecionamos:
    
- Família de informações e indicadores: informações financeiras, informações de água e informações de esgoto.
- Informações e indicadores: todos (91 selecionados)
    
**4.** Foi então baixado um arquivo `.csv`.

**Nota**: para ler a base, o arquivo `.csv` baixado do SNIS foi aberto com o programa Numbers (iOS) e então exportado para `.xlsx`. Possível causa: o arquivo `.csv` era um arquivo binário.

O script utilizado para importação e limpeza da base por ser encontrado [aqui](https://github.com/openvironment/ods6/blob/main/data-raw/snis.R).