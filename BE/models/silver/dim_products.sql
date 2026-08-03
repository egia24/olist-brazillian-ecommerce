with casting as(
    select
        sp.product_id::varchar(50) as product_id,
        sct.product_category_name_english ::varchar(100) as product_category_name_english,
        sp.product_weight_g::NUMERIC(10,2)           as product_weight_g,
        sp.product_length_cm::NUMERIC(10,2)          as product_length_cm,
        sp.product_height_cm::NUMERIC(10,2)          as product_height_cm,
        sp.product_width_cm::NUMERIC(10,2)           as product_width_cm
    from {{ ref('stg_products') }} sp left join {{ ref('stg_category_name_translation') }} sct 
        on lower(trim(regexp_replace(sp.product_category_name, '\s+', ' ', 'g'))) = lower(trim(regexp_replace(sct.product_category_name, '\s+', ' ', 'g')))
),

transform as(
    select
        product_id,
        coalesce(
            nullif(trim(initcap(replace(product_category_name_english, '_', ' '))), ''),'Uncategorized'
        ) as product_category ,
        product_weight_g,
        product_length_cm,
        product_height_cm,
        product_width_cm
    from casting
),

product_dedup as (
    select
        *,
        row_number() over(
                partition by product_id
                order by product_id
                ) as rn 
    from transform
)

select 
    {{ dbt_utils.generate_surrogate_key(['product_id']) }} as product_key,
    product_id,
    product_category,
    product_weight_g,
    product_length_cm,
    product_height_cm,
    product_width_cm
from product_dedup
where rn = 1