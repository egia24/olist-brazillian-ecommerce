with fact as (
    select * from {{ ref('fct_order_items') }}
),

dim_sellers as (
    select * from {{ ref('dim_sellers') }}
)

select
    ds.seller_key,
    ds.seller_id,
    count(distinct f.order_id)      as total_orders,
    count(f.fact_order_item_id)     as total_items_sold,
    count(distinct f.product_key)   as total_unique_products,
    count(distinct f.customer_key)  as total_unique_customers,
    round(sum(f.price)::numeric, 2)          as total_revenue,
    round(sum(f.freight_value)::numeric, 2)  as total_freight,
    round(
        (sum(f.price) / nullif(count(f.fact_order_item_id), 0))::numeric,
        2
    ) as avg_item_price
from fact f
join dim_sellers ds on f.seller_key = ds.seller_key
group by ds.seller_key, ds.seller_id
order by total_revenue desc