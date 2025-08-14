## Documentação de Transformações - Tabela `bookings_extras`

Este modelo é responsável por criar a tabela auxiliar bookings extras desmembrando os extras que estao em jsonb na tabela bookings.
---

### Colunas da Tabela

| Coluna          | Transformação Adicional                              |
|-----------------|------------------------------------------------------|
| `booking_id`    |                                                      |
| `reference`     | Desmembrada de JsonB para coluna                     |
| `net_price`     | Desmembrada de JsonB para coluna                     |
|-----------------|------------------------------------------------------|
