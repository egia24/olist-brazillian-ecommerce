SELECT
    id                          AS seller_id,
    seller_postal_code_prefix,
    seller_city,
    seller_state
FROM {{ ref('stg_sellers') }}