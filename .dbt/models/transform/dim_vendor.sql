WITH vendor_cte AS (
	SELECT DISTINCT
	    {{ dbt_utils.generate_surrogate_key(['vendor_number', 'vendor_name']) }} as vendor_id,
	  	CAST(REGEXP_REPLACE(vendor_number, r'\.0$', '') as INT64) as vendor_number,
      	vendor_name
	FROM {{ source('sales', 'raw_sales') }}
	WHERE vendor_number IS NOT NULL
	LIMIT 1000
)
SELECT v.*
FROM vendor_cte v
