{{ config(materialized='table') }}

WITH facebook AS (
    SELECT
        SHA2(CONCAT_WS('|', 'facebook', ad_group_id), 256)
            AS adgroup_key,
        'facebook' AS platform,
        ad_group_id,
        ad_group_name,
        CAST(NULL AS STRING) AS campaign_id,
        ad_group_updated_at AS updated_at
    FROM {{ ref('stg_facebook_adgroups') }}
),

snapchat_ranked AS (
    SELECT
        ad_group_id,
        campaign_id,
        ad_group_name,
        ad_group_updated_at,
        ROW_NUMBER() OVER (
            PARTITION BY ad_group_id
            ORDER BY ad_group_updated_at DESC NULLS LAST,
                     _surrogate_key DESC
        ) AS row_num
    FROM {{ ref('stg_snapchat_adgroups') }}
),

snapchat AS (
    SELECT
        SHA2(CONCAT_WS('|', 'snapchat', ad_group_id), 256)
            AS adgroup_key,
        'snapchat' AS platform,
        ad_group_id,
        ad_group_name,
        campaign_id,
        ad_group_updated_at AS updated_at
    FROM snapchat_ranked
    WHERE row_num = 1
)

SELECT * FROM facebook
UNION ALL
SELECT * FROM snapchat