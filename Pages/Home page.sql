
--Top order by date--

select to_char(o.ORDER_TIMESTAMP, 'Mon DD, YYYY') order_day, 
SUM(o.ORDER_TOTAL) sales
from DEMO_ORDERS o
group by to_char(o.ORDER_TIMESTAMP, 'Mon DD, YYYY'), ORDER_TIMESTAMP
order by 2 desc nulls last
fetch first 5 rows only


--Sales for this months--

select sum(o.ORDER_TOTAL) total_sales, count(distinct o.ORDER_ID) total_orders,
count(distinct o.CUSTOMER_ID) total_customers
from DEMO_ORDERS o
where ORDER_TIMESTAMP >= to_date(to_char(sysdate, 'YYYYMM')||'01','YYYYMMDD')


--Sales by products--

SELECT p.product_name||' [$'||p.list_price||']' product, 
       SUM(oi.quantity * oi.unit_price) sales
FROM   demo_order_items oi, demo_product_info p
WHERE  oi.product_id = p.product_id
GROUP BY p.product_id, p.product_name, p.list_price
ORDER BY p.product_name desc


--Sales by catagory--

select p.CATEGORY Category, SUM(o.ORDER_TOTAL) Sales
From DEMO_ORDERS o, DEMO_ORDER_ITEMS oi, DEMO_PRODUCT_INFO p
where o.ORDER_ID = oi.ORDER_ID
and oi.PRODUCT_ID = p.PRODUCT_ID
group by CATEGORY
order by 2 desc


--Top customers--

select b.CUST_LAST_NAME||','||b.CUST_FIRST_NAME||'-'||count(a.ORDER_ID)||'(Orders)' customer_name,
sum(a.ORDER_TOTAL) order_total, b.CUSTOMER_ID id
from DEMO_ORDERS a, DEMO_CUSTOMERS b
where a.CUSTOMER_ID = b.CUSTOMER_ID
group by b.CUSTOMER_ID, b.CUST_LAST_NAME||','||b.CUST_FIRST_NAME
order by nvl(sum(a.ORDER_TOTAL),0)DESC


--Top products--

SELECT  p.product_name||' - '||SUM(oi.quantity)||' x' 
        ||to_char(p.list_price,'L999G99')||'' product,
        SUM(oi.quantity * oi.unit_price) sales,  p.product_id
FROM demo_order_items oi,    demo_product_info p
WHERE oi.product_id = p.product_id
GROUP BY p.Product_id, p.product_name, p.list_price
ORDER BY 2 desc
