WITH extras AS (
    SELECT * FROM {{ ref('stg_bookings_extras') }}
),
accommodations AS (
    SELECT * FROM {{ ref('stg_accommodations') }}
),
bookings AS (
    SELECT * FROM {{ ref('int_confirmed_bookings') }}
),
fetch_bookings_extras AS (
    SELECT
        DATE_TRUNC('month', b.checkin_date)::date AS month,
        b.accommodation_id,
        e.net_price
    FROM bookings b
    JOIN extras e ON e.booking_id = b.booking_id
    WHERE e.reference = '10'
),
split_by_location AS (
    SELECT
        accommodation_id,
        CASE
            WHEN city = 'São Paulo' THEN 'SP'
            WHEN zone = 'Barra' THEN 'Barra'
            WHEN zone = 'ZonaX' THEN 'ZonaX'
            WHEN zone IN ('Zona1','Zona2','Zona3','Zona4','Zona5') THEN 'Matriz'
            WHEN name like 'CR-%' THEN 'Casa Rio'
            ELSE 'N/A'
        END AS cost_center
    FROM accommodations
),
fetch_cost_center_cleaning AS (
    SELECT e.month, e.net_price, a.cost_center
    FROM fetch_bookings_extras e
    JOIN split_by_location a ON e.accommodation_id = a.accommodation_id
)
SELECT
    cost_center,
    month,
    SUM(net_price) AS month_value
FROM fetch_cost_center_cleaning
GROUP BY month, cost_center
ORDER BY month DESC, cost_center
