with src as (
  select * from {{ ref('stg_reviews') }}
)
select
  review_id,
  checkin_date::date as checkin_date,
  1                  as is_review,
  case lower(channel_name)
    when 'booking.com' then 'Booking'
    else initcap(channel_name)
  end as channel_norm
from src
where checkin_date is not null;
