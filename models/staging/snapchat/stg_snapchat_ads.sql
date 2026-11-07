SELECT
    CAST(ad_id AS STRING) AS ad_id,
    CAST(ad_group_id AS STRING) AS ad_group_id,
    ad_name,
    ad_detail_updated_at
FROM {{ source('bronze', 'snapchat_ads') }}
