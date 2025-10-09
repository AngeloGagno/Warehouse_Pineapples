with beyond_data as (
    select * from {{ref('int_beyond_data')}}
),
sales as (
SELECT
  *,
  {{ calc_ajuste('booked_30_days','avg_review_value',70,50,8.8)}} AS discount_30_days
FROM beyond_data
)

select * from sales