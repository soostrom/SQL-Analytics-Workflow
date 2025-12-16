WITH cte1_imports AS (SELECT c.customer_id, c.company_name, c.region, o.order_date, o.order_id, od.product_id, od.unit_price, od.quantity, 
                             od.discount, p.product_name, e.first_name, e.last_name
                      FROM customers as c
                      LEFT JOIN orders as o on c.customer_id = o.customer_id
                      LEFT JOIN order_details as od on o.order_id = od.order_id
                      LEFT JOIN products as p on od.product_id = p.product_id
                      LEFT JOIN employees as e on o.employee_id = e.employee_id),

     cte2_transform AS (SELECT cte1_imports.customer_id, cte1_imports.company_name, cte1_imports.region, cte1_imports.order_date, cte1_imports.order_id, cte1_imports.product_id, cte1_imports.unit_price, cte1_imports.quantity, 
                             cte1_imports.discount, cte1_imports.product_name, round((quantity * unit_price)) as net_revenue, 
                             (round((quantity * unit_price) * (1 - discount))) as revenue_after_discount, CONCAT(cte1_imports.first_name,' ', cte1_imports.last_name) AS full_name 
                        FROM cte1_imports
                        WHERE order_date >= '1996-01-01' AND order_date < '1996-12-31' OR
                              cte1_imports.region NOT IN ('RJ', 'DF') OR cte1_imports.region IS NULL
                      )                        
   
SELECT * FROM cte2_transform ;