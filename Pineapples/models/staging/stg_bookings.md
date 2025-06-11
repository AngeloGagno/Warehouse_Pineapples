## Documentação de Transformações - Tabela `bookings`

Este modelo é responsável por renomear colunas da camada Raw (extraída via API) e aplicar transformações para limpeza, padronização e conversão de tipos de dados.

---

### Colunas Renomeadas

| Coluna Original       | Nova Coluna          | Transformação Adicional                              |
|-----------------------|----------------------|-------------------------------------------------------|
| `id_booking`          | `booking_id`         | Apenas renomeada                                     |
| `check_in_data`       | `checkin_date`       | Convertida para data: `to_date(check_in_data, 'YYYY-MM-DD')` |
| `check_out_data`      | `checkout_date`      | Convertida para data: `to_date(check_out_data, 'YYYY-MM-DD')` |
| `reservation_date`    | `reservation_date`   | Convertida para data: `to_date(reservation_date, 'YYYY-MM-DD')` |
| `update_date`         | `update_date`        | Convertida para data: `to_date(update_date, 'YYYY-MM-DD')` |
| `status`              | `booking_status`     | Apenas renomeada                                     |
| `accommodation_code`  | `accommodation_id`   | Apenas renomeada                                     |
| `total_payment`       | `gross_payment`      | Apenas renomeada                                     |
| `extra_value`         | `extra_payment`      | Apenas renomeada                                     |
| `portal_comission`    | `portal_payment`     | Apenas renomeada                                     |
| `extra_descrition`    | `extra_description`  | Substituição de aspas simples por duplas e convertido para `jsonb`: `REPLACE(extra_description, '''', '"')::jsonb` |

---

### Observações

- As colunas de data foram convertidas explicitamente usando a função `to_date(...)` para garantir consistência no formato `YYYY-MM-DD`.
- A coluna `extra_description` foi sanitizada para substituir aspas simples por aspas duplas, possibilitando sua conversão segura para o tipo `jsonb`.
- O nome da coluna `extra_descrition` parece conter um erro de digitação (o correto seria `extra_description`). A transformação atual já corrige esse ponto no nome final.

