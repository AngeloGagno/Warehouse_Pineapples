## Documentação de Transformações - Tabela `owner_service`

Este modelo é responsável por renomear as colunas extraídas da camada Raw (via API) para padronização e melhoria na legibilidade dos dados referentes aos proprietários.

---

### Colunas Renomeadas

| Coluna Original     | Nova Coluna      | Transformação Adicional  |
|---------------------|------------------|----------------------------|
| `id_atendimento`    | `id`             | Apenas renomeada           |
| `data`              | `registered_date`| Apenas renomeada           |
| `canal`             | `channel`        | Apenas renomeada           |
| `origem`            | `origin`         | Apenas renomeada           |
| `imovel`            | `accommodation`  | Apenas renomeada           |
| `assunto`           | `topic`          | Apenas renomeada           |
| `detalhamento`      | `details`        | Apenas renomeada           |
---