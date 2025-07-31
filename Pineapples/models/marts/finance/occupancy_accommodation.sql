with
confirmed_bookings as (
    select * from {{ref('int_confirmed_bookings')}}
),
enabled_listings as (
    select * from {{ref('int_active_accommodations')}}
),
  estadias as (
  select
    accommodation_id,
    generate_series(checkin_date, checkout_date - interval '1 day', interval '1 day')::date as dia
  from confirmed_bookings sb)
,
dias_mes as (
  select
    accommodation_id,
    date_trunc('month', dia)::date as mes,
    count(distinct dia) as dias_ocupados
  from estadias
  group by accommodation_id, date_trunc('month', dia)
),
dias_totais as (
  select
    a.accommodation_id,
    a.name,
    gs.mes,
    date_part('day', gs.mes + interval '1 month - 1 day')::int as dias_no_mes
  from (
    select
      sb.accommodation_id,
      date_trunc('month', min(sb.checkin_date)) as data_inicio,
      sa.name
    from confirmed_bookings sb
    join enabled_listings sa on sa.accommodation_id = sb.accommodation_id
    group by sb.accommodation_id, sa.name
  ) a
  cross join lateral (
    select generate_series(
      a.data_inicio,
      date_trunc('month', current_date + interval '1 year'),
      interval '1 month'
    )::date as mes
  ) gs
),
occupancy as (
select
  d.name,
  d.accommodation_id,
  d.mes,
  coalesce(dm.dias_ocupados, 0) as dias_ocupados,
  d.dias_no_mes,
  round(coalesce(dm.dias_ocupados, 0)::numeric / d.dias_no_mes * 100, 2) as taxa_ocupacao_percent
from dias_totais d
left join dias_mes dm
  on d.accommodation_id = dm.accommodation_id and d.mes = dm.mes
order by d.accommodation_id, d.mes
)
select * from occupancy order by name, mes
