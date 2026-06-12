SELECT DISTINCT
    order_purchase::DATE                        AS date,
    EXTRACT(year FROM order_purchase)::INT      AS year,
    EXTRACT(quarter FROM order_purchase)::INT   AS quarter,
    EXTRACT(month FROM order_purchase)::INT     AS month,
    EXTRACT(day FROM order_purchase)::INT       AS day,
    TO_CHAR(order_purchase, 'Month')            AS month_name,
    TO_CHAR(order_purchase, 'Day')              AS day_name
FROM {{ ref('stg_orders') }}
WHERE order_purchase IS NOT NULL