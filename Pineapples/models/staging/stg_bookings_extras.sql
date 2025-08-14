with source as (
    select * from {{ref('stg_bookings')}}
),
extras as (
SELECT
  t.booking_id,
  r.reference,
  r.net_price
FROM staging.stg_bookings AS t
CROSS JOIN LATERAL jsonb_to_recordset(t.extra_description) AS r(
  reference text,
  net_price numeric
))
select * from extras
