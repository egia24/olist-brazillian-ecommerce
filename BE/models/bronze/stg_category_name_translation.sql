select 
    product_category_name,
    product_category_name_english
from {{source('brazillian_eccommerce', 'product_category_name_translation')}}