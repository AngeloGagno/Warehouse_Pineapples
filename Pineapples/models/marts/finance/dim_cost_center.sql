with src as (
  select
    accommodation_id,
    name,
    city,
    zone
  from {{ ref('stg_accommodations') }}   -- mesma origem usada hoje no seu CASE
),

rules as (
  select
    accommodation_id,
    name as accommodation_name,
    case
      when city = 'São Paulo' then 'SP'
      when zone = 'Barra' then 'Barra'
      when zone = 'ZonaX' then 'ZonaX'
      when zone in ('Zona1','Zona2','Zona3','Zona4','Zona5') then 'Matriz'
      when name like 'CR-%' then 'Casa Rio'
      else 'N/A'
    end as cost_center_name
  from src
)

select
  accommodation_id,
  accommodation_name,
  cost_center_name
from rules