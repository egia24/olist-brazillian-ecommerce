select
    seller_id::VARCHAR(50) as id,
    seller_zip_code_prefix::varchar(10) as seller_postal_code_prefix,
    seller_city::VARCHAR(100) as seller_city,
    seller_state::CHAR(2) as seller_state
from {{source('olist_ecommerce', 'olist_sellers_dataset')}}