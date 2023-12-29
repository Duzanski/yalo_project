SELECT
  s.store_name,
  SUM(fs.sale_dollars) as total_revenue,
FROM {{ ref('fact_sales') }} fs
JOIN {{ ref('dim_store') }} s ON fs.store_id = s.store_id
GROUP BY s.store_name,
ORDER BY total_revenue DESC
LIMIT 10