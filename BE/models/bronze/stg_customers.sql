SELECT 
    customer_id,
    customer_unique_id,
    customer_zip_code_prefix,
    customer_city,
    customer_state
FROM {{ source('brazillian_ecommerce', 'olist_customers_dataset') }}
