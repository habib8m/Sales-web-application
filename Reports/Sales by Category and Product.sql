
--Donut Chart Series--

select p.category label, sum(o.order_total) total_sales
from demo_orders o, demo_order_items oi, demo_product_info p
where o.order_id = oi.order_id and oi.product_id = p.product_id
group by category order by 2 desc


--Maximum & Minimum  Sales by Product--

select p.product_id, p.product_name, min(oi.quantity), max(oi.quantity) 
from demo_product_info p, demo_order_items oi
where p.product_id = oi.product_id
group by p.product_id, p.product_name
order by p.product_name asc
