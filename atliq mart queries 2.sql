SELECT * FROM retail_events_db.fact_events;
 
 
 ## ad-hoc-buisness request 1
 SELECT p.product_name, f.product_code, f.promo_type
FROM dim_products AS p
INNER JOIN fact_events AS f ON p.product_code = f.product_code
WHERE f.base_price > 500 AND f.promo_type = 'BOGOF'
order by product_name asc;
