-- Q1: The total number of order place
select count(*) AS Total_orders from orderss;

-- Q2: The total revenue generated from pizza sales

select round(sum(od.quantity * p.price)) As Total_Revenue from order_details od
inner join pizzas p on od.pizza_id = p.pizza_id;

-- Q3: The highest priced pizza.

select max(price) as Highest_priced from pizzas;


-- Q4: The most common pizza size ordered.

select p.size, sum(od.quantity) as Total_quantity from order_details od join 
pizzas p on od.pizza_id = p.pizza_id 
group by p.size order by Total_quantity DESC limit 1 ;

-- Q5: The top 5 most ordered pizza types along their quantities.
select distinct p.pizza_type_id as pizza_type,sum(od.quantity) as Total_quantity from pizza_types pt join 
pizzas p on pt.pizza_type_id = p.pizza_type_id inner join
order_details od on p.pizza_id = od.pizza_id
group by p.pizza_type_id order by Total_quantity desc limit 5;

-- Q6: The quantity of each pizza categories ordered.

SELECT pt.category, SUM(od.quantity) AS total_quantity
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category
ORDER BY total_quantity DESC;

-- Q7: The distribution of orders by hours of the day.

SELECT HOUR(order_time) AS order_hour, COUNT(*) AS total_orders
FROM orderss
GROUP BY order_hour
ORDER BY order_hour;


-- Q8: The category-wise distribution of pizzas.
SELECT pt.category, COUNT(p.pizza_id) AS total_pizzas
FROM pizzas p
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category
ORDER BY total_pizzas DESC;


-- Q9: The average number of pizzas ordered per day.
SELECT AVG(daily_pizza_count) AS avg_pizzas_per_day
FROM (
    SELECT DATE(o.order_date) AS order_date, SUM(od.quantity) AS daily_pizza_count
    FROM orderss o
    JOIN order_details od ON o.order_id = od.order_id
    GROUP BY DATE(o.order_date)
) daily_counts;



-- Q10: Top 3 most ordered pizza type base on revenue.
SELECT pt.name AS pizza_name, SUM(od.quantity * p.price) AS total_revenue
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name
ORDER BY total_revenue DESC
LIMIT 3;

-- Q11: The percentage contribution of each pizza type to revenue.
SELECT 
    pt.name AS pizza_name, 
    SUM(od.quantity * p.price) AS total_revenue,
    (SUM(od.quantity * p.price) / (SELECT SUM(od.quantity * p.price) FROM order_details od JOIN pizzas p ON od.pizza_id = p.pizza_id)) * 100 AS percentage_contribution
FROM 
    order_details od
JOIN 
    pizzas p ON od.pizza_id = p.pizza_id
JOIN 
    pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY 
    pt.name
ORDER BY 
    percentage_contribution DESC;

-- Q12: The cumulative revenue generated over time.
SELECT 
    order_date,
    total_revenue,
    SUM(total_revenue) OVER (ORDER BY order_date) AS cumulative_revenue
FROM (
    SELECT 
        o.order_date,
        SUM(od.quantity * p.price) AS total_revenue
    FROM 
        orderss o
    JOIN 
        order_details od ON o.order_id = od.order_id
    JOIN 
        pizzas p ON od.pizza_id = p.pizza_id
    GROUP BY 
        o.order_date
) daily_revenue
ORDER BY 
    order_date;

-- Q13: The top 3 most ordered pizza type based on revenue for each pizza category.
SELECT 
    pt.category,
    pt.name AS pizza_name, 
    SUM(od.quantity * p.price) AS total_revenue
FROM 
    order_details od
JOIN 
    pizzas p ON od.pizza_id = p.pizza_id
JOIN 
    pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY 
    pt.category, pt.name
ORDER BY 
    pt.category, total_revenue DESC;


SELECT pt.name AS pizza_type, 
       SUM(od.quantity * p.price) AS total_revenue
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name
ORDER BY total_revenue DESC
LIMIT 3;


