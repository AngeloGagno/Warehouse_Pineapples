with filtered_data as (
    select 
        date_trunc('month', review_date) as month, 
        accommodation_name, 
        review_value, 
        cleaning_value, 
        coalesce(accommodation_value, cleaning_value) as maintence_value 
    from {{ref('stg_reviews')}} sr 
),
accommodations as (
    select * from {{ref('stg_accommodations')}}
),
filtered_accommodations as (
select month,
accommodation_name,
review_value,
cleaning_value,
maintence_value from filtered_data fd join accommodations sa on fd.accommodation_name = sa.name 
where sa.status = 'ENABLED'
),
groupped_data as (
    select 
        month, 
        accommodation_name, 
        avg(review_value) as avg_review,
        avg(cleaning_value) as avg_cleaning,
        avg(maintence_value) as avg_maintence_value,
        count(*) as review_count
    from filtered_accommodations
    group by month, accommodation_name
),
bottom_reviews as (
    select *, 'avaliacao geral' as worst_metric,
        row_number() over (partition by month order by avg_review asc) as rn
    from groupped_data
),
bottom_cleaning as (
    select *, 'limpeza' as worst_metric,
        row_number() over (partition by month order by avg_cleaning asc) as rn
    from groupped_data
),
bottom_maintence as (
    select *, 'manutencao' as worst_metric,
        row_number() over (partition by month order by avg_maintence_value asc) as rn
    from groupped_data
),
unioned as (
    select * from bottom_reviews where rn <= 10
    union all
    select * from bottom_cleaning where rn <= 10
    union all
    select * from bottom_maintence where rn <= 10
)
select 
    month::date::varchar,
    accommodation_name,
    avg_review,
    avg_cleaning,
    avg_maintence_value,
    review_count,
    worst_metric
from unioned
order by month desc, worst_metric, avg_review