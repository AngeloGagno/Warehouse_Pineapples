## Documentação de Transformações - Tabela `airbnb_reviews`

Este modelo é responsável por renomear colunas da camada Raw (extraída via API) e aplicar transformações para limpeza, padronização e conversão de tipos de dados.

### Alterações Realizadas:

| Coluna Original       | Nova Coluna         | Transformação Adicional                    |
|-----------------------|---------------------|--------------------------------------------|
| `scrap_ID`            | `scrap_id`          | Apenas renomeada                           |
| `airbnb_account_id`   | `scrap_id`          | replace(airbnb_account_id,'.0','')                        |
