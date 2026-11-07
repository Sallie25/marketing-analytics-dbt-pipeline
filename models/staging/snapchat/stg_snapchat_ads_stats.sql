SELECT
    CAST(ad_detail_id AS STRING) AS ad_detail_id,
    UPPER(TRIM(ad_currency_code)) AS currency_code,
    UPPER(TRIM(ad_country)) AS country,
    ad_date,
    TRY_CAST(ad_spend AS DECIMAL(18, 4)) AS spend,
    TRY_CAST(ad_impressions AS BIGINT) AS impressions,
    TRY_CAST(ad_clicks AS BIGINT) AS clicks,
    data_src,
    'snapchat' AS platform
FROM {{ source('bronze', 'snapchat_ads_stats') }}
