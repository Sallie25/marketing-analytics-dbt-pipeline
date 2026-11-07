{{ config(materialized='table') }}

WITH facebook AS (
    SELECT
        SHA2(CONCAT_WS('|', 'facebook', campaign_id), 256)
            AS campaign_key,
        'facebook' AS platform,
        campaign_id,
        campaign_name,
        CAST(NULL AS STRING) AS account_id,
        campaign_updated_at AS updated_at
    FROM {{ ref('stg_facebook_campaigns') }}
),

snapchat AS (
    SELECT
        SHA2(CONCAT_WS('|', 'snapchat', campaign_id), 256)
            AS campaign_key,
        'snapchat' AS platform,
        campaign_id,
        campaign_name,
        account_id,
        CAST(NULL AS TIMESTAMP) AS updated_at
    FROM {{ ref('stg_snapchat_campaigns') }}
)

SELECT * FROM facebook
UNION ALL
SELECT * FROM snapchat