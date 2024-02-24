SELECT * FROM retail_events_db.fact_events;



 SELECT distinct p.product_name,f.product_code,f.promo_type
 from dim_products as p
 inner join fact_events as f 
 on p.product_code = f.product_code
 where base_price > 500 and promo_type = " BOGOF"
 order by product_name asc;
 
 
 SELECT p.product_name, f.product_code, f.promo_type
FROM dim_products AS p
INNER JOIN fact_events AS f ON p.product_code = f.product_code
WHERE f.base_price > 500 AND f.promo_type = 'BOGOF'
order by product_name asc;
