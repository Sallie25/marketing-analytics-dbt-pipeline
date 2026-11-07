SELECT
    CAST(campaign_id AS STRING) AS campaign_id,
    campaign_name,
    campaign_updated_at
FROM {{ source('bronze', 'facebook_campaigns') }}
