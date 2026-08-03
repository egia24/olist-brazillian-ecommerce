with fact as (
    select * from {{ ref('fct_order_items') }}
),

dim_status as (
    select * from {{ ref('dim_status') }}
),

order_level as (
    select
        order_id,
        status_key,
        count(fact_order_item_id)  as order_item_count,
        sum(price)                 as order_revenue,
        sum(freight_value)         as order_freight
    from fact
    group by order_id, status_key
)

select
    {{ dbt_utils.generate_surrogate_key(['ds.order_status']) }} as agg_status_summary_key,
    ds.order_status,
    count(distinct ol.order_id)     as total_orders,
    sum(ol.order_item_count)        as total_items,
    round(sum(ol.order_revenue)::numeric, 2) as total_revenue,
    round(sum(ol.order_freight)::numeric, 2) as total_freight,
    round(
        (sum(ol.order_revenue + ol.order_freight) / nullif(count(distinct ol.order_id), 0))::numeric,
        2
    ) as avg_order_value
from order_level ol
join dim_status ds on ol.status_key = ds.status_key
group by ds.order_status
order by total_orders desc