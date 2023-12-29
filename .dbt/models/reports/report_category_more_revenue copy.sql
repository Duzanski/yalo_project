SELECT
  c.category_name,
  SUM(fs.sale_dollars) as total_revenue,
FROM {{ ref('fact_sales') }} fs
JOIN {{ ref('dim_category') }} c ON fs.category_id = s.category_id
GROUP BY c.category_name,
ORDER BY total_revenue DESC
LIMIT 10