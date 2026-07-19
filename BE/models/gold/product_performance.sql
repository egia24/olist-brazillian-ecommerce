SELECT
    p.product_category,
    COUNT(DISTINCT oi.order_id)     AS total_orders,
    SUM(oi.total_value)             AS total_revenue,
    AVG(oi.price)                   AS avg_price,
    SUM(oi.freight_value)           AS total_freight,
    AVG(oi.weight_g)                AS avg_weight_g,
    AVG(oi.volume_cm3)              AS avg_volume_cm3
FROM {{ ref('fct_order_items') }} oi
LEFT JOIN {{ ref('dim_products') }} p ON oi.product_id = p.product_id
GROUP BY 1
ORDER BY total_revenue DESC