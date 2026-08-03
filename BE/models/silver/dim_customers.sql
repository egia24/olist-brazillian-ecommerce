with stg_orders as(
    select
        order_id,
        customer_id,
        order_purchase_timestamp::TIMESTAMP
    from {{ref('stg_orders')}}
),


casting as(
    select
        customer_id::VARCHAR(50) as customer_id,
        customer_unique_id::VARCHAR(50) as customer_unique_id,
        customer_zip_code_prefix::VARCHAR(10) as customer_zip_code_prefix,
        customer_city::VARCHAR(100) as customer_city,
        customer_state::CHAR(2) as customer_state
    from {{ ref('stg_customers') }}
),

transform as(
    select
        customer_id,
        customer_unique_id,
        customer_zip_code_prefix,
        initcap(trim(regexp_replace(customer_city, '\s+', ' ', 'g')))as customer_city,
        upper(trim(customer_state)) as customer_state
    from casting
),

dedup as(
    select
        t.customer_id,
        t.customer_unique_id,
        t.customer_zip_code_prefix,
        t.customer_city,
        t.customer_state,
        so.order_purchase_timestamp,
        row_number() over(partition by customer_unique_id order by order_purchase_timestamp desc) rn
    from transform t left join stg_orders so on t.customer_id = so.customer_id
)

select 
    {{ dbt_utils.generate_surrogate_key(['customer_unique_id']) }} as customer_key,
    customer_unique_id,
    customer_zip_code_prefix,
    customer_city,
    customer_state
from dedup
where rn = 1 and customer_unique_id is not null