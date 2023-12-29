WITH store_cte AS (
	SELECT DISTINCT 
		{{ dbt_utils.generate_surrogate_key(['store_number', 'store_name', 'address', 'city', 'zip_code', 'county_number', 'county'])}} as store_id,
		CAST(store_number as INT64) as store_number,
		store_name,
		address,
		city,
		CAST(REGEXP_REPLACE(zip_code, r'\.0$', '') as INT64) as zip_code,
		store_location,
		CAST(county_number as INT64) as county_number,
		county
	FROM {{ source('sales', 'raw_sales') }}
	WHERE store_number IS NOT NULL
)
SELECT s.*
FROM store_cte s