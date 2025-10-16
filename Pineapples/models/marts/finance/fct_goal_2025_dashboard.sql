WITH confirmed_bookings AS (
  SELECT * FROM {{ ref('dim_confirmed_bookings') }}
), 

daily_rate AS (
  SELECT
    checkin_date AS date,
    gross_payment / NULLIF((checkout_date - checkin_date), 0) AS ADR,
    gross_payment,
    gross_payment AS order_value,
    (checkout_date - checkin_date) AS nights
  FROM confirmed_bookings
), 
monthly_rate AS (
  SELECT
    date_trunc('month', date)::date AS month,
    ROUND(SUM(gross_payment)) AS gross_payment,
    COUNT(*) AS bookings,
    ROUND(AVG(order_value)) AS average_order_value,
    ROUND(AVG(ADR)) AS ADR,
    AVG(nights) AS nights
  FROM daily_rate
  GROUP BY month
)

SELECT *
FROM monthly_rate
ORDER BY month DESC
