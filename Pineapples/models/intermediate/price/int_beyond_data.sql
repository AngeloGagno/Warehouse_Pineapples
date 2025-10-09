WITH accommodation AS (
    SELECT * FROM {{ ref('stg_accommodations') }}
),
beyond_detailed_data AS (
    SELECT * FROM {{ ref('stg_beyond_detailed_data') }}
),
beyond_booking_update AS (
    SELECT * FROM {{ ref('stg_beyond_booking_update') }}
),
reviews AS (
    SELECT 
        accommodation_name, 
        round(AVG(review_value),2) AS avg_review_value
    FROM {{ ref('stg_reviews') }}
    GROUP BY accommodation_name
),
filtered_data AS (
    SELECT 
        sa.name,
        r.avg_review_value,            
        bd.price_cluster,
        bd.base_price,
        bd.minimum_price,
        bd.last_booking_date,
        sbbu.booked_30_days,
        sbbu.booked_60_days,
        sbbu.booked_90_days,
        sbbu.scrap_date
    FROM beyond_detailed_data bd
    JOIN accommodation sa 
        ON sa.accommodation_id = bd.accommodation_id
    JOIN (
        SELECT DISTINCT ON (beyond_id) *
        FROM beyond_booking_update
        ORDER BY beyond_id, scrap_date DESC
    ) sbbu 
        ON bd.beyond_id = sbbu.beyond_id
    LEFT JOIN reviews r 
        ON r.accommodation_name = sa.name  -- juntar por ID
    WHERE bd.beyond_status IS TRUE
    ORDER BY sa.name
)
select * from filtered_data