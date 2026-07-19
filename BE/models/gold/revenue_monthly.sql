SELECT
    d.year,
    d.month,
    d.month_name,
    d.quarter,
    COUNT(DISTINCT o.order_id)      AS total_orders,
    SUM(o.total_payment_value)      AS total_revenue,
    AVG(o.total_payment_value)      AS avg_order_value,
    SUM(CASE WHEN o.is_on_time THEN 1 ELSE 0 END) AS on_time_orders,
    COUNT(DISTINCT o.customer_id)   AS total_customers
FROM {{ ref('fct_orders') }} o
LEFT JOIN {{ ref('dim_date') }} d ON o.date_id = d.date_id
GROUP BY 1,2,3,4
ORDER BY 1,2