SELECT
    id                          AS customer_id,
    customer_postal_code_prefix,
    customer_city,
    customer_state
FROM {{ ref('stg_customers') }}