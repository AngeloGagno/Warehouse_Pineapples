## Documentação de Transformações - Tabela `owner`

Este modelo é responsável por renomear as colunas extraídas da camada Raw (via API) para padronização e melhoria na legibilidade dos dados referentes aos proprietários.

---

### Colunas Renomeadas

| Coluna Original     | Nova Coluna     | Transformação Adicional  |
|---------------------|------------------|----------------------------|
| `id_proprietario`   | `owner_id`       | Apenas renomeada           |
| `nome`              | `name`           | Apenas renomeada           |
| `documento`         | `identification` | Apenas renomeada           |
| `telefone`          | `phone`          | Apenas renomeada           |

---

### Observações

- A transformação consiste apenas na renomeação direta das colunas, sem alteração de tipos ou aplicação de regras de limpeza.
- O modelo visa fornecer uma camada mais clara e compatível para análise e integração com outras entidades (ex: `bookings`, `accommodation`).