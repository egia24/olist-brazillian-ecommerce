with fact as (
    select * from {{ ref('fct_order_items') }}
),

dim_date as (
    select * from {{ ref('dim_date') }}
),

monthly as (
    select
        dd.year as order_year,
        dd.month as order_month,
        dd.month_name as order_month_name,
        dd.year_month,
        f.fact_order_item_id,
        f.order_id,
        f.customer_key,
        f.price,
        f.freight_value
    from fact f
    join dim_date dd
        on f.purchase_date_key = dd.date_key
)

select
    {{ dbt_utils.generate_surrogate_key(['year_month']) }} as agg_monthly_sales_key,
    order_year,
    order_month,
    order_month_name,
    year_month,
    count(distinct order_id) as total_orders,
    count(fact_order_item_id) as total_items,
    count(distinct customer_key) as total_unique_customers,
    round(sum(price)::numeric, 2) as total_revenue,
    round(sum(freight_value)::numeric, 2) as total_freight,
    round(
        (sum(price + freight_value) / nullif(count(distinct order_id), 0))::numeric,
        2
    ) as avg_order_value,
    round(
        (sum(price) / nullif(count(fact_order_item_id), 0))::numeric,
        2
    ) as avg_item_price
from monthly
group by
    order_year,
    order_month,
    order_month_name,
    year_month
order by
    year_month