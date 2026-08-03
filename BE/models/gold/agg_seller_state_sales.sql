with fact as (
    select * from {{ ref('fct_order_items') }}
),

dim_sellers as (
    select * from {{ ref('dim_sellers') }}
),

dim_date as (
    select * from {{ ref('dim_date') }}
),

agg as (
    select
        dd.year as order_year,
        dd.month as order_month,
        dd.month_name as order_month_name,
        dd.year_month,
        ds.seller_state,
        count(distinct f.order_id) as total_orders,
        count(distinct f.seller_key) as total_unique_sellers,
        count(f.fact_order_item_id) as total_items,
        round(sum(f.price)::numeric, 2) as total_revenue,
        round(sum(f.freight_value)::numeric, 2) as total_freight,
        round(
            (sum(f.price + f.freight_value) / nullif(count(distinct f.order_id), 0))::numeric,
            2
        ) as avg_order_value
    from fact f
    join dim_sellers ds
        on f.seller_key = ds.seller_key
    join dim_date dd
        on cast(f.order_purchase_timestamp as date) = dd.date_day
    group by
        dd.year,
        dd.month,
        dd.month_name,
        dd.year_month,
        ds.seller_state
)

select
    {{ dbt_utils.generate_surrogate_key(['seller_state', 'year_month']) }} as agg_seller_state_key,
    order_year,
    order_month,
    order_month_name,
    year_month,
    seller_state,
    total_orders,
    total_unique_sellers,
    total_items,
    total_revenue,
    total_freight,
    avg_order_value
from agg
order by
    year_month,
    total_revenue desc