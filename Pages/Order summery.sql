
--Order hrader--

begin
for x in (select c.cust_first_name, c.cust_last_name, cust_street_address1, cust_street_address2, cust_city, cust_state, cust_postal_code from demo_customers c, demo_orders o
where c.customer_id = o.customer_id and o.order_id = :P14_ORDER_ID)
loop
    htp.p('<span style="font-size:16px;font-weight:bold;">ORDER #' || sys.htf.escape_sc(:P14_ORDER_ID) || '</span><br />');
    htp.p(sys.htf.escape_sc(x.cust_first_name) || ' ' || sys.htf.escape_sc(x.cust_last_name) ||'<br />');
    htp.p(sys.htf.escape_sc(x.cust_street_address1) || '<br />');
    if x.cust_street_address2 is not null then
        htp.p(sys.htf.escape_sc(x.cust_street_address2) || '<br />');
    end if;
    htp.p(sys.htf.escape_sc(x.cust_city) || ', ' || sys.htf.escape_sc(x.cust_state) || '  ' || sys.htf.escape_sc(x.cust_postal_code) || '<br /><br />');
end loop;
end;


--Order lines--

select p.product_name, oi.unit_price, oi.quantity, (oi.unit_price * oi.quantity) extended_price   
from demo_order_items oi, demo_product_info p
where oi.product_id = p.product_id and oi.order_id = :P14_ORDER_ID
