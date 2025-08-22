WITH reviews_2025 AS (
    SELECT * 
    FROM  {{ref('stg_reviews')}} 
    WHERE checkin_date >= '2025-01-01'
),
airbnb_reviews AS (
    SELECT 
        r.accommodation_name,
        AVG(r.review_value) AS review_value,
        COUNT(r.review_value) AS review_count, 
        aar.publishment_status 
    FROM reviews_2025 r join marts.accommodation_airbnb_reviews aar on r.accommodation_name = aar.accommodation_name
    WHERE r.channel_name = 'Airbnb'
    GROUP BY r.accommodation_name, aar.publishment_status
),
booking_reviews AS (
    SELECT 
        accommodation_name, 
        AVG(review_value) AS review_value,
        COUNT(review_value) AS review_count 
    FROM reviews_2025
    WHERE channel_name = 'Booking'
    GROUP BY accommodation_name
),
booking_goal AS (
    SELECT 
        accommodation_name, 
        CEIL((review_count * 8 - review_count * review_value) / (10 - 8)) AS avaliacoes_10_booking, 
        review_value AS review_value_booking 
    FROM booking_reviews
    ORDER BY accommodation_name ASC
),
airbnb_goal AS (
    SELECT 
        accommodation_name,
        publishment_status,
        CEIL((review_count * 9.2 - review_count * review_value) / (10 - 9.2)) AS avaliacoes_5_airbnb,
        round(review_value/2,1) AS review_value_airbnb
    FROM airbnb_reviews
    ORDER BY accommodation_name ASC
),
booking_reviews_needed AS (
    SELECT  
        accommodation_name,
        CASE
            WHEN avaliacoes_10_booking <= 0 THEN 0
            ELSE avaliacoes_10_booking
        END AS avaliacoes_10_booking, 
        review_value_booking
    FROM booking_goal
),
airbnb_reviews_needed AS (
    SELECT 
        accommodation_name, 
        publishment_status,
        CASE
            WHEN avaliacoes_5_airbnb <= 0 THEN 0
            ELSE avaliacoes_5_airbnb
        END AS avaliacoes_5_airbnb,
        review_value_airbnb
    FROM airbnb_goal
),
join_airbnb_booking AS (
    SELECT 
        ab.accommodation_name, 
        ab.publishment_status,
        ab.avaliacoes_5_airbnb::varchar, 
        ab.review_value_airbnb::varchar, 
        bc.avaliacoes_10_booking::varchar,
        ROUND(bc.review_value_booking,1)::varchar AS review_value_booking
    FROM airbnb_reviews_needed ab 
    LEFT JOIN booking_reviews_needed bc 
        ON ab.accommodation_name = bc.accommodation_name 
),
change_dot_comma AS (
    SELECT 
        accommodation_name, 
        publishment_status,
        avaliacoes_5_airbnb, 
        REPLACE(review_value_airbnb,'.',',') AS review_value_airbnb,
        avaliacoes_10_booking,  
        REPLACE(review_value_booking,'.',',') AS review_value_booking
    FROM join_airbnb_booking
),
enabled_accommodations as ( 
	select a.name,cd.publishment_status, cd.avaliacoes_5_airbnb, cd.review_value_airbnb,
	cd.avaliacoes_10_booking, cd.review_value_booking from change_dot_comma cd right join staging.stg_accommodations a on a.name = cd.accommodation_name 
	where a.status = 'ENABLED'),
airbnb_banned_accommodations_filter as ( 
	select name, 
	case 
		when publishment_status = 'error' then 'Banido/Suspenso'
		else avaliacoes_5_airbnb
		end as avaliacoes_5_airbnb,
		review_value_airbnb, avaliacoes_10_booking,review_value_booking from enabled_accommodations)
select * from airbnb_banned_accommodations_filter order by name asc