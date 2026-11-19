SELECT * FROM customer_analysis.fact_sales;


-- Q1 what is the Total Revenue generted by Males vs. Females 

select  gender, round(sum(total_price), 2) as total_revenue
from fact_sales
where order_status = 'Completed'
group by  gender 
order by total_revenue desc ;


-- Q2 What is the Total Revenue per product Type 

select product_type, round(sum(total_price), 2) as total_revenue
from fact_sales
where order_status = 'Completed'
group by product_type
order by total_revenue desc ;

-- Q3. What are the top 3 most purchased products within each product type 

WITH product_counts AS 
(
    SELECT
        product_type,
        sku,
        COUNT(customer_id) AS total_orders,
        ROW_NUMBER() OVER(PARTITION BY product_type ORDER BY COUNT(customer_id) DESC) AS product_rank,
        order_status
    FROM
        fact_sales
    WHERE order_status = 'Completed'
    GROUP BY product_type, sku, order_status
)
SELECT
    product_rank,
    sku AS product_name,
    product_type,
    total_orders
FROM
    product_counts
WHERE product_rank <= 3;



-- Q4. Compare the average unit price between Standard and Express Shipping 

select shipping_type , round(avg(unit_price), 2) as avg_unit_price from fact_sales
where shipping_type in ('Express', 'Standard')
group by shipping_type 
order by avg_unit_price desc ;

-- Q5. What is the revenue contribution of each age group 

