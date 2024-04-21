
--Customer orders--

select c.customer_id,  c.cust_last_name||', '||c.cust_first_name Customer_Name,
       sum (decode(p.category,'Men',oi.quantity * oi.unit_price,0)) "Men",
       sum (decode(p.category,'Women',oi.quantity * oi.unit_price,0)) "Women",
       sum (decode(p.category,'Kids',oi.quantity * oi.unit_price,0)) "Kids"
from demo_customers c, demo_orders o, demo_order_items oi, demo_product_info p
where c.customer_id = o.customer_id and o.order_id = oi.order_id and oi.product_id = p.product_id
group by c.customer_id, c.cust_last_name, c.cust_first_name
order by c.cust_last_name


--Horizontal Orientation--

$("#dualChart_jet").ojChart({orientation: 'horizontal'});

--Vertical Orientation--

$("#dualChart_jet").ojChart({orientation: 'vertical'});

--Stack Chart--

$("#dualChart_jet").ojChart({stack: 'on'});

--Unstack Chart--

$("#dualChart_jet").ojChart({stack: 'off'});
