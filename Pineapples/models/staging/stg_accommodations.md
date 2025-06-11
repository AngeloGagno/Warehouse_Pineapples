## Documentação de Transformações - Tabela `accommodations`

Este modelo é responsável por renomear colunas da camada Raw (extraída via API) e aplicar transformações para limpeza, padronização e conversão de tipos de dados.

### Alterações Realizadas:

| Coluna Original       | Nova Coluna         | Transformação Adicional                   |
|-----------------------|---------------------|--------------------------------------------|
| `id_acc`              | `accommodation_id`  | Apenas renomeada                           |
| `id_proprietario`     | `owner_id`          | Apenas renomeada                           |
| `nome_acomodacao`     | `name`              | Apenas renomeada                           |
| `zona`                | `zone`              | Apenas renomeada                           |
| `tamanho`             | `size`              | Convertida para `numeric`                  |
| `qtde_quartos`        | `bedrooms`          | Apenas renomeada                           |
| `qtde_banheiros`      | `bathrooms`         | Apenas renomeada                           |
| `cama`                | `bed`               | Limpeza de caracteres: `regexp_replace(cama, '[}{'']', '', 'g')` |
| `cod_pais`            | `country`           | Apenas renomeada                           |
| `cidade`              | `city`              | Apenas renomeada                           |
| `endereco`            | `address`           | Apenas renomeada                           |
| `bairro`              | `neighborhood`      | Apenas renomeada                           |

