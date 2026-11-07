-- Fails if the fact table loses, duplicates, or changes performance keys.
WITH intermediate AS (
    SELECT
        performance_key,
        COUNT(*) AS row_count
    FROM {{ ref('int_ad_performance') }}
    GROUP BY performance_key
),
fact AS (
    SELECT
        performance_key,
        COUNT(*) AS row_count
    FROM {{ ref('fact_ad_performance') }}
    GROUP BY performance_key
)
SELECT
    COALESCE(i.performance_key, f.performance_key) AS performance_key,
    i.row_count AS intermediate_count,
    f.row_count AS fact_count
FROM intermediate i
FULL OUTER JOIN fact f
    ON i.performance_key = f.performance_key
WHERE COALESCE(i.row_count, 0) <> COALESCE(f.row_count, 0)
