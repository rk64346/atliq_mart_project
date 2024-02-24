SELECT * FROM retail_events_db.fact_events;
ALTER TABLE fact_events
DROP COLUMN promo_price;
SELECT distinct promo_type FROM retail_events_db.fact_events;


SELECT c.campaign_name, 
       fe.promo_type,
       ROUND(SUM(CASE 
                  WHEN promo_type = '50% OFF' THEN base_price * 0.5 * fe.`quantity_sold(after_promo)`
                  WHEN promo_type = '25% OFF' THEN base_price * 0.75 * fe.`quantity_sold(after_promo)`
                  WHEN promo_type = 'BOGOF' THEN base_price * 0.5 * fe.`quantity_sold(after_promo)` * 2
                  WHEN promo_type = '500 Cashback' THEN (base_price - 500) * fe.`quantity_sold(after_promo)`
                  ELSE  base_price * 0.67 * fe.`quantity_sold(after_promo)`
                END)/1000000, 2) as promo_revenue
FROM fact_events as fe
LEFT JOIN dim_campaigns as c ON fe.campaign_id = c.campaign_id
GROUP BY c.campaign_name, fe.promo_type;

SELECT 
    c.campaign_name, 
    ROUND(SUM(
        CASE 
            WHEN promo_type = '50% OFF' THEN base_price * 0.5 * fe.`quantity_sold(after_promo)`
            WHEN promo_type = '25% OFF' THEN base_price * 0.75 * fe.`quantity_sold(after_promo)`
            WHEN promo_type = 'BOGOF' THEN base_price * 0.5 * fe.`quantity_sold(after_promo)` * 2
            WHEN promo_type = '500 Cashback' THEN (base_price - 500) * fe.`quantity_sold(after_promo)`
            ELSE  base_price * 0.67 * fe.`quantity_sold(after_promo)`
        END
    )/1000000, 2) as total_promo_revenue,
    ROUND(SUM(base_price * fe.`quantity_sold(before_promo)`)/1000000, 2) as total_revenue_before_promo
FROM 
    fact_events as fe
LEFT JOIN 
    dim_campaigns as c ON fe.campaign_id = c.campaign_id
GROUP BY 
    c.campaign_name;


SELECT
  p.category,
  ROUND((SUM(f.`quantity_sold(after_promo)` - f.`quantity_sold(before_promo)`) / SUM(f.`quantity_sold(before_promo)`) * 100), 2) AS ISU_PER,
  RANK() OVER (ORDER BY SUM(f.`quantity_sold(after_promo)` - f.`quantity_sold(before_promo)`) / SUM(f.`quantity_sold(before_promo)`) DESC) AS RANK_ORDER
FROM
  dim_products AS p
INNER JOIN
  fact_events AS f ON p.product_code = f.product_code
WHERE
  f.campaign_id = "CAMP_DIW_01"
GROUP BY
  p.category;


SELECT
  p.product_name,
  p.category,
  ROUND(
    ((SUM(`quantity_sold(after_promo)` * base_price) - 
      SUM(`quantity_sold(before_promo)` * base_price)) / 
     SUM(`quantity_sold(before_promo)` * base_price)) * 100, 2) AS IR_PERCENTAGE
FROM
  dim_products AS p
INNER JOIN
  fact_events AS f ON p.product_code = f.product_code
GROUP BY
  p.product_name, p.category
ORDER BY
  IR_PERCENTAGE DESC
LIMIT 5;

