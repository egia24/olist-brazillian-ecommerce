with stg_orders_items as(
    select
        {{ dbt_utils.generate_surrogate_key(['order_id', 'order_item_id']) }} as fact_order_item_id,
        order_item_id,
        order_id,
        product_id,
        seller_id,
        shipping_limit_date,
        price::numeric,
        freight_value::numeric
    from {{ source('brazillian_ecommerce', 'olist_order_items_dataset') }}
),

orders as(
    select
        so.order_id,
        so.customer_id,
        sc.customer_unique_id,
        lower(trim(so.order_status)) as order_status,
        so.order_purchase_timestamp::timestamp as order_purchase_timestamp,
        nullif(so.order_approved_at,'')::timestamp as order_approved_at,
        nullif(so.order_delivered_carrier_date,'')::timestamp as order_delivered_carrier_date,
        nullif(so.order_delivered_customer_date,'')::timestamp as order_delivered_customer_date,
        nullif(so.order_estimated_delivery_date,'')::timestamp as order_estimated_delivery_date
    from {{ ref('stg_orders') }} so
    left join {{ ref('stg_customers') }} sc on so.customer_id = sc.customer_id
),

dim_status as (
    select * from {{ ref('dim_status') }}
),

dim_customers as (
    select * from {{ ref('dim_customers') }}
),

dim_products as (
    select * from {{ ref('dim_products') }}
),

dim_sellers as (
    select * from {{ ref('dim_sellers') }}
)

select
    soi.fact_order_item_id,
    soi.order_item_id,
    o.order_id,
    dc.customer_key,
    dp.product_key,
    dse.seller_key,
    ds.status_key,
    soi.shipping_limit_date,
    soi.price,
    soi.freight_value,
    o.order_purchase_timestamp, 
    o.order_approved_at,
    o.order_delivered_carrier_date,
    o.order_delivered_customer_date,
    o.order_estimated_delivery_date
from stg_orders_items soi
join orders o on soi.order_id = o.order_id
left join dim_customers dc on o.customer_unique_id = dc.customer_unique_id
left join dim_status ds on o.order_status = ds.order_status
left join dim_products dp on soi.product_id = dp.product_id
left join dim_sellers dse on soi.seller_id = dse.seller_id