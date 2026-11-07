SELECT
    CAST(account_id AS STRING) AS account_id,
    account_name,
    UPPER(TRIM(ad_currency_code)) AS currency_code,
    account_created_at,
    account_updated_at
FROM {{ source('bronze', 'facebook_accounts') }}
