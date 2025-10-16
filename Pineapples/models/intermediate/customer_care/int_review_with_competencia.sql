-- models/intermediate/int_reviews_with_competencia.sql
with source as (select * from {{ ref('stg_reviews') }})
select
  booking_id,
  checkin_date::date,
  case
    when date_part('day', checkin_date) >= 21
      then (date_trunc('month', checkin_date)::date + interval '21 days')::date
    else (date_trunc('month', checkin_date)::date - interval '1 month' + interval '21 days')::date
  end as competencia,
  service_value::numeric(5,2),
  communication_value::numeric(5,2),
  checkin_value::numeric(5,2)
from source
where checkin_date is not null
