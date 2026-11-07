{% snapshot snap_snapchat_adgroups %}

{{
    config(
        target_database=env_var('DATABRICKS_ANALYTICS_CATALOG'),
        target_schema='snapshots',
        unique_key='ad_group_id',
        strategy='check',
        check_cols=['ad_group_name', 'campaign_id'],
        invalidate_hard_deletes=True
    )
}}

WITH ranked AS (
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
)

SELECT
    ad_group_id,
    campaign_id,
    ad_group_name,
    ad_group_updated_at
FROM ranked
WHERE row_num = 1

{% endsnapshot %}