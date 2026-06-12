SELECT
    soi.id,
    soi.order_id,
    soi.product_id,
    soi.seller_id,
    so.customer_id,
    so.status,
    so.order_purchase,
    so.order_delivered_customer_date,
    soi.price,
    soi.freight_value,
    sp.category,
    sp.weight_g,
    ss.seller_city,
    ss.seller_state,
    sc.customer_city,
    sc.customer_state,
    (so.order_delivered_customer_date::date - so.order_purchase::date)    AS delivery_days
FROM {{ ref('stg_order_items') }} soi        
left JOIN {{ ref('stg_orders') }} so        ON soi.order_id = so.id
left JOIN {{ ref('stg_products') }} sp      ON soi.product_id = sp.id
left JOIN {{ ref('stg_sellers') }} ss       ON soi.seller_id = ss.id
left JOIN {{ ref('stg_customers') }} sc     ON so.customer_id = sc.id