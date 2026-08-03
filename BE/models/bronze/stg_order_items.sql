select 
    order_item_id,
    order_id,
    product_id,
    seller_id,
    shipping_limit_date,
    price,
    freight_value
from {{ source('brazillian_ecommerce', 'olist_order_items_dataset')}}