{{ config(materialized='table') }}

WITH date_bounds AS (
    SELECT
        MIN(ad_date) AS min_date,
        MAX(ad_date) AS max_date
    FROM {{ ref('int_ad_performance') }}
),

calendar AS (
    SELECT EXPLODE(
        SEQUENCE(min_date, max_date, INTERVAL 1 DAY)
    ) AS calendar_date
    FROM date_bounds
)

SELECT
    CAST(DATE_FORMAT(calendar_date, 'yyyyMMdd') AS INT) AS date_key,
    calendar_date,
    YEAR(calendar_date) AS year,
    QUARTER(calendar_date) AS quarter,
    MONTH(calendar_date) AS month,
    DAY(calendar_date) AS day_of_month,
    WEEKOFYEAR(calendar_date) AS week_of_year,
    DATE_FORMAT(calendar_date, 'EEEE') AS day_name
FROM calendar