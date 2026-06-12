SELECT
    category,
    COUNT(DISTINCT order_id)    AS total_orders,
    SUM(price)                  AS total_revenue
FROM {{ref('int_order_items')}} ioi
WHERE category IS NOT NULL
GROUP BY 1
ORDER BY 3 DESC
LIMIT 5