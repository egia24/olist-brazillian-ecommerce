{% snapshot customers_snapshot %}

-- depends_on: {{ ref('stg_customers') }}

{{
    config(
        target_schema='snapshot',
        unique_key='customer_id',
        strategy='check',
        check_cols=['customer_postal_code_prefix', 'customer_city', 'customer_state'],
        invalidate_hard_deletes=True
    )
}}

SELECT
    customer_id,
    customer_postal_code_prefix,
    customer_city,
    customer_state
FROM {{ ref('stg_customers') }}

{% endsnapshot %}