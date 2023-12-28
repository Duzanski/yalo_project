WITH store_cte AS (
	SELECT 
		{{ dbt_utils.generate_surrogate_key(['store_number', 'store_name', 'address', 'city', 'zip_code', 'county_number', 'county'])}} as store_id,
		store_number,
		store_name,
		address,
		city,
		REGEXP_REPLACE(zip_code, r'\.0$', '') as zip_code,
		store_location,
		county_number,
		county
	FROM {{ source('sales', 'raw_sales') }}
	WHERE store_number IS NOT NULL
)
SELECT s.*
FROM store_cte s