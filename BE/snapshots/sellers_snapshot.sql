{% snapshot sellers_snapshot %}

-- depends_on: {{ ref('stg_sellers') }}

{{
    config(
        target_schema='snapshot',
        unique_key='seller_id',
        strategy='check',
        check_cols=['seller_postal_code_prefix', 'seller_city', 'seller_state'],
        invalidate_hard_deletes=True
    )
}}

SELECT
    seller_id,
    seller_postal_code_prefix,
    seller_city,
    seller_state
FROM {{ ref('stg_sellers') }}

{% endsnapshot %}