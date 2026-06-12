select 
    order_item_id::VARCHAR(10)                  as id,
    order_id::VARCHAR(50)                       as order_id,
    product_id::VARCHAR(50)                     as product_id,
    seller_id::VARCHAR(50)                      as seller_id,
    NULLIF(shipping_limit_date, '')::TIMESTAMP  as shipping_limit_date,
    price::NUMERIC(12,2)                        as price,
    freight_value::NUMERIC(10,2)                as freight_value
from {{ source('olist_ecommerce', 'olist_order_items_dataset')}}