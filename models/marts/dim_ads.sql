{{ config(materialized='table') }}

WITH facebook AS (
    SELECT
        SHA2(
            CONCAT_WS('|', 'facebook', ad_id),
            256
        ) AS ad_key,
        'facebook' AS platform,
        ad_id,
        ad_name,
        ad_status,
        campaign_id,
        ad_group_id,
        account_id,
        ad_updated_at AS updated_at
    FROM {{ ref('stg_facebook_ads') }}
),

snapchat AS (
    SELECT
        SHA2(
            CONCAT_WS('|', 'snapchat', ad_id),
            256
        ) AS ad_key,
        'snapchat' AS platform,
        ad_id,
        ad_name,
        CAST(NULL AS STRING) AS ad_status,
        CAST(NULL AS STRING) AS campaign_id,
        ad_group_id,
        CAST(NULL AS STRING) AS account_id,
        ad_detail_updated_at AS updated_at
    FROM {{ ref('stg_snapchat_ads') }}
)

SELECT * FROM facebook
UNION ALL
SELECT * FROM snapchat