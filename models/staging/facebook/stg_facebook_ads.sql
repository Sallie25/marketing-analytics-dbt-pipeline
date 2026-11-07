SELECT
    CAST(ad_id AS STRING) AS ad_id,
    CAST(campaign_id AS STRING) AS campaign_id,
    CAST(ad_group_id AS STRING) AS ad_group_id,
    CAST(account_id AS STRING) AS account_id,
    ad_name,
    ad_status,
    ad_updated_at
FROM {{ source('bronze', 'facebook_ads') }}
