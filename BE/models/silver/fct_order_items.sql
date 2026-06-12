SELECT
    -- foreign keys ke dim
    id,
    order_id,
    product_id,
    seller_id,
    customer_id,
    order_purchase::DATE        AS date_id, 
    price,
    freight_value,
    delivery_days,
    (price + freight_value)     AS total_charged
FROM {{ ref('int_order_items') }}