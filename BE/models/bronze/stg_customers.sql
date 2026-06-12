SELECT 
    customer_id::VARCHAR(50)    as id,
    customer_zip_code_prefix::varchar(10) as customer_postal_code_prefix,
    customer_city::VARCHAR(100) as customer_city,
    customer_state::char(2) as customer_state
FROM {{ source('olist_ecommerce', 'olist_customers_dataset') }}
