-- Fails if any performance record has negative spend, impressions, or clicks.
SELECT
    performance_key,
    spend,
    impressions,
    clicks
FROM {{ ref('fact_ad_performance') }}
WHERE spend < 0
   OR impressions < 0
   OR clicks < 0
