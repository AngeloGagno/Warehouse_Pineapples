## Documentação de Transformações - Tabela `reviews`

Este modelo é responsável por renomear colunas da camada Raw (via API) e aplicar transformações para padronização e conversão de dados relacionados às avaliações de hospedagens.

---

### Colunas Renomeadas

| Coluna Original          | Nova Coluna               | Transformação Adicional                                |
|--------------------------|---------------------------|---------------------------------------------------------|
| `id_booking`             | `booking_id`              | Apenas renomeada                                       |
| `positive_review`        | `positive_review_field`   | Apenas renomeada                                       |
| `negative_review`        | `negative_review_field`   | Apenas renomeada                                       |
| `service_value`          | `service_value`           | `NULLIF(..., 'N/A')::numeric`                          |
| `cleaning_value`         | `cleaning_value`          | `NULLIF(..., 'N/A')::numeric`                          |
| `accommodation_value`    | `accommodation_value`     | `NULLIF(..., 'N/A')::numeric`                          |
| `location_value`         | `location_value`          | `NULLIF(..., 'N/A')::numeric`                          |
| `truthfulness_value`     | `truthfulness_value`      | `NULLIF(..., 'N/A')::numeric`                          |
| `checkin_value`          | `checkin_value`           | `NULLIF(..., 'N/A')::numeric`                          |
| `communication_value`    | `communication_value`     | `NULLIF(..., 'N/A')::numeric`                          |

---

### Observações

- Os campos de nota que podem conter `'N/A'` foram convertidos para `NULL` e, em seguida, transformados para tipo `numeric`, garantindo consistência e permitindo operações quantitativas.
- A renomeação de campos de review positivo/negativo ajuda a evitar ambiguidade e melhora a clareza semântica.

