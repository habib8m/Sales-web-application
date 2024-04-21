
select o.rowid,
       o.order_id,
       to_date(to_char(o.order_timestamp,'mm yyyy'), 'mm yyyy') order_month,
       o.order_timestamp order_date,
       o.user_name sales_rep, 
       o.order_total,
       c.cust_last_name || ', ' || c.cust_first_name customer_name,
       (select count(*) from demo_order_items  oi 
        where oi.order_id = o.order_id) order_items,
       o.tags tags
from  demo_orders o, demo_customers c
where o.customer_id = c.customer_id
order by order_timestamp desc