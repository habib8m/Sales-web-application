
--Sales by category (line)--

select p.category type, trunc(o.order_timestamp) when, sum (oi.quantity * oi.unit_price) sales
from demo_product_info p, demo_order_items oi, demo_orders o
where oi.product_id = p.product_id and o.order_id = oi.order_id
group by p.category, trunc(o.order_timestamp), to_char(o.order_timestamp, 'YYYYMM')
order by to_char(o.order_timestamp, 'YYYYMM')


--Sales by Month (Bar)--

select p.category type, to_char(o.order_timestamp, 'MON RRRR') month, sum (oi.quantity * oi.unit_price) sales
from demo_product_info p, demo_order_items oi, demo_orders o
where oi.product_id = p.product_id  and o.order_id = oi.order_id
group by p.category, to_char(o.order_timestamp, 'MON RRRR'), to_char(o.order_timestamp, 'YYYYMM')
order by to_char(o.order_timestamp, 'YYYYMM')