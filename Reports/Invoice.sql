
Select o.order_id, o.Order_timestamp, o.user_name, 
       c.cust_first_name || ' ' || c.cust_last_name as customer, 
       c.cust_street_address1, c.cust_street_address2, c.cust_city, 
       c.cust_state, c.cust_postal_code, oi.ORDER_ITEM_ID, 
       pi.PRODUCT_NAME, oi.UNIT_PRICE, oi.QUANTITY, 
       oi.Unit_Price * oi.Quantity as Amount
from   DEMO_ORDERS o, DEMO_ORDER_ITEMS oi, 
       DEMO_PRODUCT_INFO pi, DEMO_CUSTOMERS c 
where  o.ORDER_id = oi.ORDER_id and pi.PRODUCT_ID = oi.PRODUCT_ID and 
       o.customer_id = c.customer_id and 
       o.ORDER_id BETWEEN :P50_INVOICEFROM and 
       :P50_INVOICETO and o.user_name = :P50_USER

