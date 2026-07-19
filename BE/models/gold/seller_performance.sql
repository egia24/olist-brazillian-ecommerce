SELECT
    s.seller_id,
    s.city,
    s.state,
    COUNT(DISTINCT oi.order_id)     AS total_orders,
    SUM(oi.total_value)             AS total_revenue,
    AVG(oi.price)                   AS avg_price,
    SUM(oi.freight_value)           AS total_freight,
    COUNT(DISTINCT oi.product_id)   AS total_products_sold,
    AVG(o.actual_delivery_days)     AS avg_delivery_days,
    ROUND(SUM(CASE WHEN o.is_on_time THEN 1 ELSE 0 END) * 100.0 / COUNT(DISTINCT oi.order_id), 2) AS on_time_pct
FROM {{ ref('fct_order_items') }} oi
LEFT JOIN {{ ref('dim_sellers') }} s ON oi.seller_id = s.seller_id
LEFT JOIN {{ ref('fct_orders') }} o ON oi.order_id = o.order_id
GROUP BY 1,2,3
ORDER BY total_revenue DESC