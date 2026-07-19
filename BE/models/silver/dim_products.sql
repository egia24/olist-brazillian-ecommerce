with stg_products as(
    select
        product_id::varchar(50),
        product_category_name_english::varchar(100) AS product_category,
        product_weight_g::NUMERIC(10,2),
        product_length_cm::NUMERIC(10,2),
        product_height_cm::NUMERIC(10,2),
        product_width_cm::NUMERIC(10,2)
    from {{ref('stg_products')}} sp
    left join {{ref('stg_category_name_translation')}} sct sp.product_category_name = sct.product_category_name
),

product_dedup as (
    select
        *,
        row_number() over(
                partition by product_id, product_category
                ) as rn 
    from stg_products
)

select 
    *
from product_dedup
where rn = 1
