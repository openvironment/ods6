## Indicadores

Nas seções a seguir, descrevemos o cálculo dos indicadores. O cálculo dos indicadores se referem aos anos de 2011 a 2018, utilizando dados de referência (censo 2010) e projeções do SEADE para o número de domicílios particulares ocupados no período. 

Utilizaremos siglas para facilitar a notação, sendo

- DPPO: a projeção do número de domicílios particulares ocupados dada pelo SEADE (2011 a 2018).
- DPPO (censo): o número de domicílios particulares ocupados no censo de 2010.

---

##### DPPOF - Número de domicílios particulares permanentes ocupados servidos por fossa

Esse dado é obtido nos censos demográficos realizados no primeiro ano de cada década. Para os anos situados entre dois censos, supõe-se que a proporção dos domicílios particulares ocupados servidos por sistemas de fossas sépticas se mantem constante durante o período e que o número total de domicílios particulares ocupados no município segue a projeção da SEADE.

- **Cálculo**:

$$
DPPOF = \frac{DPPO}{DPPO_{censo}} \times DPPOF_{censo}
$$

DPPOF (censo): número de domicílios particulares permanentes ocupados servidos por fossa no censo de 2010.

- **Unidade**: domicílios

- **Observação**: quando a canalização do banheiro ou sanitário está conectada a um dispositivo tipo câmara, enterrado, destinado a receber o esgoto para separação e sedimentação do material orgânico e mineral, transformando-o em material inerte, seguido de unidade para a disposição da parte líquida no solo. Não são considerados nesse valor os domicílios cujos banheiros ou sanitários são ligados a uma fossa rústica (fossa negra, poço, buraco etc.), diretamente a uma vala a céu aberto, rio, lago ou mar.

---

##### DPPOPM - Número de domicílios particulares permanentes ocupados abastecidos por poços ou minas 

Esse dado é obtido nos censos demográficos realizados no primeiro ano de cada década. Para os anos situados entre dois censos, supõe-se que a proporção dos domicílios particulares permanentes ocupados abastecidos por poços ou minas se mantem constante durante o período e que o número total de domicílios particulares ocupados no município segue a projeção da SEADE.

- **Cálculo**:

$$
DPPOPM = \frac{DPPO}{DPPO_{censo}} \times DPPOAM_{censo}
$$

- **Unidade**: domicílios

-	**Observações**:
    - Domicílio era servido por água de poço ou nascente localizado no terreno ou na propriedade em que estava construído. Não devem ser considerados nesse item domicílios servidos por água de rede pública de distribuição; de poço ou nascente localizado fora do terreno ou da propriedade em que estava construído; de poço ou nascente localizado na aldeia ou fora da aldeia (em terras indígenas); transportada por carro-pipa; de chuva, armazenada em cisterna, caixa de cimento, galões, tanques de material plástico etc.; de rio, açude, lago, igarapé.

---
    
##### THD - Taxa média de habitantes por domicílio  

Constitui o número médio de habitantes por domicílio particular permanente ocupado. É obtida através da razão entre a população total residente no município (PT) pelo número de domicílios particulares permanentes ocupados no município (DPPO). Essa taxa é apurada nos censos demográficos realizados no primeiro ano da década. Para os anos situados entre dois censos demográficos, a taxa é calculada através de estimativas da população e do número de domicílios particulares permanentes ocupados realizadas por metodologia desenvolvida pelo SEADE.

- **Cálculo**: 

$$
THD = \frac{PT}{DPPO}
$$

- **Unidade**: habitantes/domicílio

---

##### PAR - População residente servida por rede pública de abastecimento de água 

População do município atendida com rede pública de abastecimento de água pelo prestador de serviços, no último dia do ano de referência. Corresponde à população que é efetivamente atendida por rede pública de distribuição, tanto na área urbana como rural. É calculada pelo produto da quantidade de economias residenciais ativas de água (AG013), multiplicada pela taxa média de habitantes por domicílio do respectivo município (THD), obtida no último censo ou contagem de população do IBGE, ou estimadas realizadas pelo SEADE.

- **Cálculo**:

$$
PAR = AG013 \times THD
$$

- **Unidade**: habitantes

---

##### PAPN - População residente servida por poço ou nascente 

População do município atendida por sistemas de abastecimento de água de poço ou nascente localizado no terreno ou na propriedade em que estava construído.

- **Cálculo**:

$$
PAPN = DPPOPM \times THD
$$

- **Unidade**: habitantes

-	**Observação**: Não devem ser considerados nesse item a população servida por água de rede pública de distribuição; de poço ou nascente localizado fora do terreno ou da propriedade em que estava construído; de poço ou nascente localizado na aldeia ou fora da aldeia, em terras indígenas; transportada por carro-pipa; de chuva, armazenada em cisterna, caixa de cimento, galões, tanques de material plástico etc.; de rio, açude, lago, igarapé.

---

##### PTA - População residente total servida por sistemas de abastecimento de água sanitariamente adequados  

População total do município atendida por sistemas sanitariamente adequados de abastecimento de água (rede pública e poços ou minas localizadas dentro do terreno do domicílio).

- **Cálculo**:

$$
PTA = PAR + PAPN
$$

- **Unidade**: habitantes

---

##### pPTA - Porcentagem da população total residente servida por água de abastecimento 

Percentual da população total do município abastecida por sistemas sanitariamente adequados de abastecimento de água.

- **Cálculo**:

$$
pPTA =\frac{PTA}{PT} \times 100
$$

- **Unidade**: %

-	**Observação**: O cálculo da pPTA pode resultar em valores superiores a 100% nos municípios que apresentem número elevado de domicílios utilizados para veraneio, imóveis desocupados, dentre outros, ou devido a deficiências de cadastro das economias residenciais. Nesses casos, deve-se adotar para esse indicador o valor de 100%.

---

##### pPAPN - Porcentagem da população total residente servida por poço ou nascentes 

Percentual da população residente total do município abastecida por poço ou nascente.

- **Cálculo**:

$$
pPAPN =\frac{PAPN}{PT} \times 100
$$

- **Unidade**: %

---
    
##### pPAR - Porcentagem da população residente servida por rede pública de abastecimento de água 

Percentual da População Abastecida por Sistema de Distribuição de Água.

- **Cálculo**:

$$
pPAR = pPTA - pPAPN
$$

- **Unidade**: %

---

##### PRE - População residente servida por rede coletora de esgoto  

População do município atendida com rede pública coletora de esgoto pelo prestador de serviços, no último dia do ano de referência. Corresponde à população que é efetivamente atendida por rede pública coletora, tanto na área urbana como rural. 

- **Cálculo**:

$$
PRE = ES008 \times THD
$$

- **Unidade**: habitantes

-	**Observações**: Caso o prestador de serviços não disponha de procedimentos próprios para definir, de maneira precisa, essa população, o mesmo poderá estimá-la utilizando o produto da quantidade de economias residenciais ativas de esgotos (ES008), multiplicada pela taxa média de habitantes por domicílio do respectivo município, obtida no último censo ou contagem de população do IBGE. Quando isso ocorrer, o prestador de serviços deverá abater da quantidade de economias residenciais ativas de esgotos, o quantitativo correspondente aos domicílios atendidos e que não contam com população residente, como, por exemplo, domicílios utilizados para veraneio, domicílios utilizados somente em finais de semana, imóveis desocupados, dentre outros. Assim, o quantitativo de economias residenciais ativas a ser considerado na estimativa populacional normalmente será inferior ao valor informado em ES008.

---

##### PSF - População residente servida por sistema de fossa séptica 

População Residente Servida por Sistema de Fossa Séptica 

- **Cálculo**:

$$
PSF = DPPOF \times THD
$$

- **Unidade**: habitantes

---

##### PTCE - População residente total servida por sistemas de coleta de esgoto 

População total residente servida por sistemas sanitariamente adequados de coleta de esgoto (rede pública coletora ou fossas sépticas). 

- **Cálculo**:

$$
PTCE = PRE + PFS
$$

- **Unidade**: habitantes

---

##### pPTCE - Porcentagem da população residente servida com sistema de coleta de esgoto 

Percentual da população total do município abastecida por Sistemas sanitariamente adequados de coleta de esgoto.

- **Cálculo**:

$$
pPTCE =\frac{PTCE}{PT} \times 100
$$

- **Unidade**: %

-	**Observação**: O cálculo do pPTCE pode resultar em valores superiores a 100% nos municípios que apresentem número elevado de domicílios utilizados para veraneio, imóveis desocupados, dentre outros, ou devido a deficiências de cadastro das economias residenciais. Nesses casos, deve-se adotar para esse indicador o valor de 100%.

---

##### pPFS - Porcentagem da população residente servida por fossa séptica 

Percentual da população residente servida por Fossa séptica.

- **Cálculo**:

$$
pPFSE =\frac{PFS}{PT} \times 100
$$

- **Unidade**: %

---

##### pPRE - Porcentagem da população residente servida por sistema rede coletora de esgoto 

Percentual da população servida por sistema de rede coletora de esgoto.

- **Cálculo**:

$$
pPRE = pPTCE - pPFS
$$

- **Unidade**: %

---

##### VAED - Volume de água efetivamente disponibilizado para consumo no município 

Volume de água de efetivamente disponibilizado para consumo potável na rede de distribuição do município. Corresponde à soma dos volumes de água produzido (AG006) e de água tratada importado (AG018), subtraindo o volume de agua tratada exportado (AG019).

- **Cálculo**:

$$
VAED = AG006 + AG018 – AG019
$$

- **Unidade**: 1.000 m³/ano

---

##### VATP - Volume total de água perdido na rede de distribuição 

Corresponde à soma volumes de perdas físicas ou reais e perdas aparentes ou não físicas.

- **Cálculo**:

$$
VATP = VAED – AG010 – AG019
$$

- **Unidade**: 1.000 m³/ano

-	**Observações**:
    - Perdas físicas ou reais se referem a volumes de água que não são consumidos, por serem perdidos através de vazamentos em seu percurso, desde as estações de tratamento de água até os pontos de entrega nos imóveis dos clientes.
    - Perdas aparentes ou não físicas correspondem aos volumes de água que são consumidos, mas não são contabilizados pela empresa, principalmente devido às irregularidades (com fraudes e ligações clandestinas, os chamados “gatos”) e à submedição dos hidrômetros.

---

##### VAEC - Volume de água efetivamente consumido no município 

Volume efetivamente consumido em todas economias de água do município ligadas à rede de distribuição pública. Corresponde à soma dos volumes de água consumido (AG010) e de perda de água aparente (estimado em 30% do volume de perda total de água ocorrido na rede de distribuição - VATP), subtraindo o volume de água tratada exportado (AG019).

- **Cálculo**:

$$
VAEC = AG010 + 0,3 \times VATP – AG019
$$

- **Unidade**: 1.000 m³/ano

---

##### CMPE - Consumo médio per capita efetivo 

Consumo diário médio efetivo de água por habitante atendido. Corresponde à razão entre o volume efetivamente consumido no município e a população atendida por rede de abastecimento de água.


- **Cálculo**:

$$
CMPE = \frac{VAEC}{(pPAR/100)\times PT} \times \frac{1.000.000}{365}
$$

- **Unidade**: Litros/habitante/dia

---

##### IPPT - Índice percentual de perdas de água na rede de distribuição 

Corresponde ao percentual de perdas totais (reais e aparentes) ocorridas no sistema de distribuição de água do município. Para efeito de cálculo desse índice, não são consideradas os volumes de água tratada exportado pela concessionaria dos serviços.

- **Cálculo**:


$$
IPPT = \frac{VATP}{VAED} \times 100
$$

- **Unidade**: %

---

##### VEEP - Volume efetivo de esgoto produzido no município 

Volume de esgoto efetivamente produzido pela totalidade das economias ativas de água do sistema público de abastecimento. Esse volume representa 80% do consumo efetivo das economias ativas de água do município, sejam elas servidas ou não por redes coletoras de esgoto.

- **Cálculo**:

$$
VEEP = 0,8 * VAEC
$$

- **Unidade**: 1.000 m³/ano

---

##### pTE - Porcentagem do Esgoto Tratado em Relação ao Produzido 

Corresponde ao percentual do volume de esgoto encaminhado pelo sistema coletor público de esgoto para tratamento em relação ao volume de esgoto produzido encaminhado pelo sistema público coletor para estações de tratamento em relação ao volume total de esgoto efetivamente produzido

- **Cálculo**:

$$
pTE = \frac{E006}{VEEP} \times 100
$$

- **Unidade**: %


