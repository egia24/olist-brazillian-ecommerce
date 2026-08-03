with fact as (
    select * from {{ ref('fct_order_items') }}
),

dim_products as (
    select * from {{ ref('dim_products') }}
)

select
    {{ dbt_utils.generate_surrogate_key(['dp.product_category']) }} as agg_product_category_key,
    dp.product_category,
    count(distinct f.order_id)          as total_orders,
    count(f.fact_order_item_id)         as total_items_sold,
    count(distinct f.seller_key)        as total_unique_sellers,
    count(distinct f.customer_key)      as total_unique_customers,
    round(sum(f.price)::numeric, 2)          as total_revenue,
    round(sum(f.freight_value)::numeric, 2)  as total_freight,
    round(avg(f.price)::numeric, 2)          as avg_item_price,
    round(avg(dp.product_weight_g)::numeric, 2) as avg_weight_g
from fact f
join dim_products dp on f.product_key = dp.product_key
group by dp.product_category
order by total_revenue desc