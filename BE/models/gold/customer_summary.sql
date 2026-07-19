SELECT
    c.customer_id,
    c.city,
    c.state,
    COUNT(DISTINCT o.order_id)      AS total_orders,
    SUM(o.total_payment_value)      AS total_spending,
    AVG(o.total_payment_value)      AS avg_order_value,
    MIN(o.order_purchase)           AS first_order_date,
    MAX(o.order_purchase)           AS last_order_date,
    CASE 
        WHEN COUNT(DISTINCT o.order_id) > 1 THEN 'Repeat'
        ELSE 'New'
    END                             AS customer_type
FROM {{ ref('fct_orders') }} o
LEFT JOIN {{ ref('dim_customers') }} c ON o.customer_id = c.customer_id
GROUP BY 1,2,3
ORDER BY total_spending DESC