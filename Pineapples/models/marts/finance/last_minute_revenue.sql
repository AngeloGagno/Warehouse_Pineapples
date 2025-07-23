
WITH bookings AS (
  SELECT
    date_trunc('week', checkin_date::date)::date AS begin_week,
    date_trunc('week', checkin_date::date)::date + INTERVAL '6 day' AS end_week,
    reservation_date,
    checkin_date,
    gross_payment,
    checkin_date - reservation_date AS antecedencia
  FROM {{ref('int_confirmed_bookings')}}

), consolidated_bookings as (
SELECT
  begin_week::varchar,
  end_week::varchar,
  COUNT(*) AS total_reservas_filtradas,
  SUM(CASE WHEN antecedencia < 7 THEN 1 ELSE 0 END) AS reservas_menor_7,
  coalesce(AVG(CASE WHEN antecedencia < 7 THEN gross_payment END)::text,'') AS media_receita_menor_7,
  SUM(CASE WHEN antecedencia BETWEEN 7 AND 14 THEN 1 ELSE 0 END) AS reservas_7_14,
  coalesce(AVG(CASE WHEN antecedencia BETWEEN 7 AND 14 THEN gross_payment END)::text,'') AS media_receita_7_14
FROM bookings
GROUP BY begin_week, end_week
ORDER BY begin_week desc)
select * from consolidated_bookings where begin_week::date <= date_trunc('week', current_date)
