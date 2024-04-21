
select o.order_id, to_char(o.order_timestamp,'Month yyyy') order_month, o.order_timestamp order_date,
           c.cust_last_name || ', ' || c.cust_first_name customer_name, 
           c.cust_state,
           o.user_name sales_rep, 
           (select count(*) from demo_order_items  oi 
             where oi.order_id = o.order_id) order_items,
           o.order_total  
from demo_orders o, demo_customers c 
where o.customer_id = c.customer_id
