WITH fct_sales AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key(['invoice_and_item_number', 'pack', 'bottle_volume_ml', 'state_bottle_cost', 'state_bottle_retail', 'bottles_sold', 'sale_dollars', 'volume_sold_liters', 'volume_sold_gallons']) }} as sales_id,
        {{ dbt_utils.generate_surrogate_key(['category', 'category_name']) }} as category_id,
        {{ dbt_utils.generate_surrogate_key(['vendor_number', 'vendor_name']) }} as vendor_id,
        {{ dbt_utils.generate_surrogate_key(['date']) }} as date_id,
        {{ dbt_utils.generate_surrogate_key(['item_description', 'item_number']) }} as item_id,
        {{ dbt_utils.generate_surrogate_key(['store_number', 'store_name', 'address', 'city', 'zip_code', 'county_number', 'county']) }} as store_id,
        invoice_and_item_number as invoice_number,
        pack,
        bottle_volume_ml,
        state_bottle_cost,
        state_bottle_retail,
        bottles_sold,
        sale_dollars,
        volume_sold_liters,
        volume_sold_gallons
    FROM {{ source('sales', 'raw_sales') }}
)

SELECT
    fs.sales_id,
    dd.date_id,
    dc.category_id,
    di.item_id,
    ds.store_id,
    dv.vendor_id,
    fs.invoice_number,
    fs.pack,
    fs.bottle_volume_ml,
    fs.state_bottle_cost,
    fs.state_bottle_retail,
    fs.bottles_sold,
    fs.sale_dollars,
    fs.volume_sold_liters,
    fs.volume_sold_gallons
FROM fct_sales fs
INNER JOIN {{ ref('dim_date') }} dd ON fs.date_id = dd.date_id
INNER JOIN {{ ref('dim_category') }} dc ON fs.category_id = dc.category_id
INNER JOIN {{ ref('dim_item') }} di ON fs.item_id = di.item_id
INNER JOIN {{ ref('dim_store') }} ds ON fs.store_id = ds.store_id
INNER JOIN {{ ref('dim_vendor') }} dv ON fs.vendor_id = dv.vendor_id
