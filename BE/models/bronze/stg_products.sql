SELECT 
    product_id:: VARCHAR(50)                as id,
    product_category_name_english:: VARCHAR(100)    as category,
    product_weight_g::NUMERIC(10,2)         as weight_g,
    product_length_cm::NUMERIC(6,2)         as length_cm,
    product_height_cm::NUMERIC(6,2)         as height_cm,
    product_width_cm::NUMERIC(6,2)          as width_cm
FROM {{ source('olist_ecommerce', 'olist_products_dataset')}} opd
left join  {{ source('olist_ecommerce', 'product_category_name_translation')}} pcnt on lower(trim(opd.product_category_name)) = lower(trim(pcnt.product_category_name))