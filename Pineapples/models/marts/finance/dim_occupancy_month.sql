-- models/marts/core/fct_occupancy_monthly.sql
{% set start_month = var('metrics_start_month', '2023-01-01') %}
{% set end_month   = var('metrics_end_month',   '2026-12-01') %}

with stays as (
  select * from {{ ref('int_stays_by_day') }}
),
days_per_month as (
  select
    s.accommodation_id,
    date_trunc('month', s.day)::date as month,
    count(distinct s.day) as occupied_days
  from stays s
  group by 1,2
),
months as (
  select generate_series(
    date_trunc('month', '{{ start_month }}'::date),
    date_trunc('month', '{{ end_month }}'::date),
    interval '1 month'
  )::date as month
),
grid as (
  select
    a.accommodation_id,
    a.accommodation_zone,
    a.accommodation_name,
    m.month
  from {{ ref('dim_accommodations_name') }} a
  cross join months m
),
joined as (
  select
    g.accommodation_id,
    g.accommodation_zone,
    g.accommodation_name,
    g.month,
    coalesce(dpm.occupied_days, 0) as occupied_days
  from grid g
  left join days_per_month dpm
    on dpm.accommodation_id = g.accommodation_id
   and dpm.month = g.month
)
select
  accommodation_id,
  accommodation_zone,
  accommodation_name,
  month,
  occupied_days,
  -- calcula dias do mês sem tabela auxiliar
  date_part('day', month + interval '1 month - 1 day')::int as days_in_month,
  round(occupied_days::numeric
        / nullif(date_part('day', month + interval '1 month - 1 day')::int, 0)
        * 100, 2) as occupancy_rate_pct
from joined
where month between '{{ start_month }}'::date and '{{ end_month }}'::date
order by accommodation_name, month
