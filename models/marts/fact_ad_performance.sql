{{ config(materialized='table') }}

WITH ad_relationships AS (
    SELECT
        a.platform,
        a.ad_id,
        a.ad_key,
        a.ad_group_id,
        CASE
            WHEN a.platform = 'facebook'
                THEN a.campaign_id
            ELSE g.campaign_id
        END AS campaign_id
    FROM {{ ref('dim_ads') }} a
    LEFT JOIN {{ ref('dim_adgroups') }} g
        ON a.platform = g.platform
       AND a.ad_group_id = g.ad_group_id
),

performance AS (
    SELECT
        p.* EXCEPT (currency_code),

        CASE
            WHEN p.platform = 'facebook'
                THEN acc.currency_code
            ELSE p.currency_code
        END AS currency_code,

        a.ad_key,
        a.ad_group_id,
        a.campaign_id

    FROM {{ ref('int_ad_performance') }} p

    LEFT JOIN ad_relationships a
        ON p.platform = a.platform
       AND p.ad_id = a.ad_id

    LEFT JOIN {{ ref('stg_facebook_accounts') }} acc
        ON p.platform = 'facebook'
       AND p.account_id = acc.account_id
)

SELECT
    p.performance_key,
    p.ad_key,

    CASE
        WHEN p.ad_group_id IS NOT NULL
        THEN SHA2(CONCAT_WS('|', p.platform, p.ad_group_id), 256)
    END AS adgroup_key,

    CASE
        WHEN p.campaign_id IS NOT NULL
        THEN SHA2(CONCAT_WS('|', p.platform, p.campaign_id), 256)
    END AS campaign_key,

    CAST(DATE_FORMAT(p.ad_date, 'yyyyMMdd') AS INT) AS date_key,

    p.platform,
    p.ad_id,
    p.account_id,
    p.currency_code,
    p.country,
    p.data_src,
    p.ad_date,

    p.spend,
    p.impressions,
    p.clicks,

    CASE
        WHEN p.impressions > 0
        THEN ROUND(
            CAST(p.clicks AS DOUBLE) * 100.0 / p.impressions, 4
        )
    END AS ctr_pct,

    CASE
        WHEN p.clicks > 0
        THEN ROUND(
            CAST(p.spend AS DOUBLE) / p.clicks, 4
        )
    END AS cpc,

    CASE
        WHEN p.impressions > 0
        THEN ROUND(
            CAST(p.spend AS DOUBLE) * 1000.0 / p.impressions, 4
        )
    END AS cpm

FROM performance p