
{{
    config(
        materialized='incremental',
        incremental_strategy='merge',
        unique_key='performance_key',
        on_schema_change='sync_all_columns',
        file_format='delta'
    )
}}

-- Standardize Facebook and Snapchat performance records
-- while retaining each platform's original reporting grain.

WITH facebook AS (

    SELECT
        SHA2(
            TO_JSON(NAMED_STRUCT(
                'platform', 'facebook',
                'ad_id', ad_id,
                'account_id', account_id,
                'ad_date', ad_date
            )),
            256
        ) AS performance_key,

        'facebook' AS platform,
        ad_id,
        account_id,
        CAST(NULL AS STRING) AS currency_code,
        CAST(NULL AS STRING) AS country,
        ad_date,
        CAST(NULL AS STRING) AS data_src,
        spend,
        impressions,
        clicks

    FROM {{ ref('stg_facebook_ads_stats') }}

    {% if is_incremental() %}
    WHERE ad_date >= (
        SELECT DATE_SUB(MAX(ad_date), 7)
        FROM {{ this }}
    )
    {% endif %}

),

snapchat AS (

    SELECT
        SHA2(
            TO_JSON(NAMED_STRUCT(
                'platform', 'snapchat',
                'ad_detail_id', ad_detail_id,
                'currency_code', currency_code,
                'country', country,
                'ad_date', ad_date,
                'data_src', data_src
            )),
            256
        ) AS performance_key,

        'snapchat' AS platform,
        ad_detail_id AS ad_id,
        CAST(NULL AS STRING) AS account_id,
        currency_code,
        country,
        ad_date,
        data_src,
        spend,
        impressions,
        clicks

    FROM {{ ref('stg_snapchat_ads_stats') }}

    {% if is_incremental() %}
    WHERE ad_date >= (
        SELECT DATE_SUB(MAX(ad_date), 7)
        FROM {{ this }}
    )
    {% endif %}

)

SELECT * FROM facebook

UNION ALL

SELECT * FROM snapchat
