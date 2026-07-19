SELECT
    c.state,
    c.city,
    COUNT(DISTINCT o.order_id)                                          AS total_orders,
    AVG(o.actual_delivery_days)                                         AS avg_delivery_days,
    AVG(o.estimated_delivery_days)                                      AS avg_estimated_days,
    SUM(CASE WHEN o.is_on_time THEN 1 ELSE 0 END)                      AS on_time_orders,
    ROUND(SUM(CASE WHEN o.is_on_time THEN 1 ELSE 0 END) * 100.0 / COUNT(DISTINCT o.order_id), 2) AS on_time_pct
FROM {{ ref('fct_orders') }} o
LEFT JOIN {{ ref('dim_customers') }} c ON o.customer_id = c.customer_id
GROUP BY 1,2
ORDER BY 1,2