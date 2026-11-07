SELECT
    CAST(ad_id AS STRING) AS ad_id,
    CAST(account_id AS STRING) AS account_id,
    ad_date,
    TRY_CAST(ad_spend AS DECIMAL(18, 4)) AS spend,
    TRY_CAST(ad_impressions AS BIGINT) AS impressions,
    TRY_CAST(ad_clicks AS BIGINT) AS clicks,
    'facebook' AS platform
FROM {{ source('bronze', 'facebook_ads_stats') }}
