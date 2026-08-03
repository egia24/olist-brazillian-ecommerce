select
    seller_id,
    seller_zip_code_prefix,
    seller_city,
    seller_state
from {{source('brazillian_ecommerce', 'olist_sellers_dataset')}}