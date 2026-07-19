with stg_customers as(
    select
    customer_id::VARCHAR(50),
    customer_postal_code_prefix::NUMERIC(10,3) AS customer_postal_code_prefix,
    customer_city::VARCHAR(100) AS customer_city,
    customer_state::CHAR(2) AS customer_state
    FROM {{ ref('stg_customers') }}
),

with customer_dedup as(
    select
    customer_id,
    customer_postal_code_prefix,
    customer_city,
    customer_state,
    row_number() over(partition by customer_id) as rn
    from stg_customers
)

select 
    *
from customer_dedup
where rn = 1
