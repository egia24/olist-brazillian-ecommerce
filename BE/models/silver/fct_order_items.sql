with stg_orders_items as(
    select
        row_number() over(partition by order_item_id, order_id) as fact_order_item_id
        order_item_id,
        order_id,
        product_id,
        seller_id,
        shipping_limit_date,
        price,
        freight_value
    from {{ source('olist_ecommerce', 'olist_order_items_dataset')}}
),

orders as(
    select
        order_id,
        customer_id,
        order_status,
        order_purchase_timestamp, 
        order_approved_at,
        order_delivered_carrier_date,
        order_delivered_customer_date
        order_estimated_delivery_date
    from {{ref('stg_orders')}}
),

dim_status as (
    select * from {{ref('dim_status')}}
),

dim_customers as (
    select * from {{ref('dim_customerss')}}
)

select
    soi.fact_order_item_id
    soi.order_item_id,
    o.order_id,
    product_id,
    sc.customer_id,
    seller_id,
    ss.status_id,
    order_purchase_timestamp, 
    order_approved_at,
    order_delivered_carrier_date,
    order_delivered_customer_date
    order_estimated_delivery_date
from stg_orders_items soi
join orders o on soi.order_id = o.order_id
join dim_customers dc on o.customer_id = dc.customer_id
join dim_status ds on o.order_status = ds.order_status


