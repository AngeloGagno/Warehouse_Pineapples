with months as (
    select generate_series('2024-01-01'::date, date_trunc('month', current_date), interval '1 month') as checkin_month
),
active_listings as (
    select name as accommodation_name
    from {{ref('stg_accommodations')}}
    where status = 'ENABLED'
),
combinations as (
    select 
        m.checkin_month,
        a.accommodation_name
    from months m
    cross join active_listings a
),
filtered_data as (
    select 
        date_trunc('month', checkin_date)::date as checkin_month,
        accommodation_name,
        review_value,
        cleaning_value
    from {{ref('stg_reviews')}}
),
aggregated_reviews as (
    select
        checkin_month,
        accommodation_name,
        avg(review_value) as avg_review,
        count(review_value) as count_reviews,
        avg(cleaning_value) as avg_cleaning,
        count(cleaning_value) as count_cleaning
    from filtered_data
    group by checkin_month, accommodation_name
),
combined as (
    select 
        c.checkin_month,
        c.accommodation_name,
        ar.avg_review,
        ar.count_reviews,
        ar.avg_cleaning,
        ar.count_cleaning
    from combinations c
    left join aggregated_reviews ar
    on c.checkin_month = ar.checkin_month
    and c.accommodation_name = ar.accommodation_name
),
final_with_weighted as (
    select *,
        sum(coalesce(avg_review * count_reviews, 0)) over w as total_review_sum,
        sum(coalesce(count_reviews, 0)) over w as total_review_count,
        sum(coalesce(avg_cleaning * count_cleaning, 0)) over w as total_cleaning_sum,
        sum(coalesce(count_cleaning, 0)) over w as total_cleaning_count
    from combined
    window w as (
        partition by accommodation_name
        order by checkin_month
        rows between unbounded preceding and current row
    )
)
select 
    checkin_month::varchar,
    accommodation_name,

    -- Médias mensais
    avg_review,
    count_reviews,
    avg_cleaning,
    count_cleaning,

    -- Médias ponderadas acumuladas
    case when total_review_count > 0 then round(total_review_sum / total_review_count, 2) else null end as weighted_review,
    case when total_cleaning_count > 0 then round(total_cleaning_sum / total_cleaning_count, 2) else null end as weighted_cleaning

from final_with_weighted
order by accommodation_name, checkin_month
