
----Order information----

select lpad(to_char(o.order_id),4,'0000') order_number, o.order_id,
       to_char(o.order_timestamp,'Month YYYY') order_month,
       trunc(o.order_timestamp) order_date,
       o.user_name sales_rep, o.order_total,
       c.cust_last_name||', '||c.cust_first_name customer_name,
       (select count(*) from demo_order_items oi
        where oi.order_id = o.order_id and oi.quantity != 0) order_items,
       o.tags tags
from  demo_orders o,  demo_customers c
where o.customer_id = c.customer_id



----Order items----

select oi.order_item_id, oi.order_id, oi.product_id, oi.unit_price, oi.quantity, 
      (oi.unit_price * oi.quantity) extended_price
from DEMO_ORDER_ITEMS oi, DEMO_PRODUCT_INFO pi 
where oi.ORDER_ID = :P29_ORDER_ID 
and oi.product_id = pi.product_id (+)


----Customer information in update page----

select apex_escape.html(cust_first_name) || ' ' || apex_escape.html(cust_last_name) || '<br />' || apex_escape.html(cust_street_address1) ||
 decode(cust_street_address2, null, null, '<br />' || apex_escape.html(cust_street_address2)) || '</br>' || apex_escape.html(cust_city) || ', ' ||
  apex_escape.html(cust_state) || '  ' || apex_escape.html(cust_postal_code) 
from demo_customers 
where customer_id = :P29_CUSTOMER_ID



----Place order----

declare
    l_order_id    number;
    l_customer_id varchar2(30) := :P11_CUSTOMER_ID;
begin
-- Create New Customer
    if :P11_CUSTOMER_OPTIONS = 'NEW' then
        insert into DEMO_CUSTOMERS (
            CUST_FIRST_NAME, CUST_LAST_NAME, CUST_STREET_ADDRESS1,
            CUST_STREET_ADDRESS2, CUST_CITY, CUST_STATE, CUST_POSTAL_CODE,
            CUST_EMAIL, PHONE_NUMBER1, PHONE_NUMBER2, URL, CREDIT_LIMIT, TAGS)
        values (
            :P11_CUST_FIRST_NAME, :P11_CUST_LAST_NAME, :P11_CUST_STREET_ADDRESS1,
            :P11_CUST_STREET_ADDRESS2, :P11_CUST_CITY, :P11_CUST_STATE,
            :P11_CUST_POSTAL_CODE, :P11_CUST_EMAIL, :P11_PHONE_NUMBER1,
            :P11_PHONE_NUMBER2, :P11_URL, :P11_CREDIT_LIMIT, :P11_TAGS)
        returning customer_id into l_customer_id;
        :P11_CUSTOMER_ID := l_customer_id;
    end if;
-- Insert a row into the Order Header table
    insert into demo_orders(customer_id, order_total, order_timestamp, user_name) 
    values  (l_customer_id, null, systimestamp, upper(:APP_USER)) 
    returning order_id into l_order_id;
    commit;
-- Loop through the ORDER collection and insert rows into the Order Line Item table
    for x in (select c001, c003, sum(c004) c004 from apex_collections 
               where collection_name = 'ORDER' group by c001, c003) loop
       insert into demo_order_items(order_item_id, order_id, product_id, unit_price, quantity)
       values (null, l_order_id, to_number(x.c001), to_number(x.c003),to_number(x.c004));
    end loop;
    commit;
-- Set the item P14_ORDER_ID to the order which was just placed
    :P14_ORDER_ID := l_order_id;
-- Truncate the collection after the order has been placed
    apex_collection.truncate_collection(p_collection_name => 'ORDER');
end;




----Selected items----

declare
  l_customer_id varchar2(30) := :P11_CUSTOMER_ID;
begin
--
-- display customer information
--
sys.htp.p('<div class="CustomerInfo">');
if :P11_CUSTOMER_OPTIONS = 'EXISTING' then
  for x in (select * from demo_customers where customer_id = l_customer_id) loop
    sys.htp.p('<div class="CustomerInfo">');
    sys.htp.p('<strong>Customer:</strong>');  
    sys.htp.p('<p>');
    sys.htp.p(sys.htf.escape_sc(x.cust_first_name) || ' ' ||
    sys.htf.escape_sc(x.cust_last_name) || '<br />');
    sys.htp.p(sys.htf.escape_sc(x.cust_street_address1) || '<br />');
    if x.cust_street_address2 is not null then
      sys.htp.p(sys.htf.escape_sc(x.cust_street_address2) || '<br />');        
    end if;
    sys.htp.p(sys.htf.escape_sc(x.cust_city) || ', ' ||
    sys.htf.escape_sc(x.cust_state) || '  ' ||
    sys.htf.escape_sc(x.cust_postal_code));
    sys.htp.p('</p>');
  end loop;
else
  sys.htp.p('<strong>Customer:</strong>');  
  sys.htp.p('<p>');
  sys.htp.p(sys.htf.escape_sc(:P11_CUST_FIRST_NAME) || ' ' ||
                sys.htf.escape_sc(:P11_CUST_LAST_NAME) || '<br />');
  sys.htp.p(sys.htf.escape_sc(:P11_CUST_STREET_ADDRESS1) || '<br />');
  if :P11_CUST_STREET_ADDRESS2 is not null then
    sys.htp.p(sys.htf.escape_sc(:P11_CUST_STREET_ADDRESS2) || '<br />');    
  end if;
  sys.htp.p(sys.htf.escape_sc(:P11_CUST_CITY) || ', ' ||
  sys.htf.escape_sc(:P11_CUST_STATE) || '  ' ||
  sys.htf.escape_sc(:P11_CUST_POSTAL_CODE));
  sys.htp.p('</p>');
end if;
sys.htp.p('</div>');

-- display products
--
sys.htp.p('<div class="Products" >');
sys.htp.p('<table width="100%" cellspacing="0" cellpadding="0" border="0">
<thead>
<tr><th class="left">Product</th><th>Price</th><th></th></tr>
</thead>
<tbody>');
for c1 in (select product_id, product_name,  list_price, 'Add to Cart' add_to_order
from demo_product_info
where product_avail = 'Y'
order by product_name) loop
sys.htp.p('<tr><td class="left">'||sys.htf.escape_sc(c1.product_name)||'</td>
<td>'||trim(to_char(c1.list_price,'999G999G990D00')) || '</td>
<td><a href="'||apex_util.prepare_url('f?p=&APP_ID.:12:'||:app_session||':ADD:::P12_PRODUCT_ID:'|| c1.product_id)||'" class="t-Button t-Button--simple t-Button--hot"><span>Add<i class="iR"></i></span></a></td>
</tr>');
end loop;
sys.htp.p('</tbody></table>');
sys.htp.p('</div>');

--
-- display current order
--
sys.htp.p('<div class="Products" >');
sys.htp.p('<table width="100%" cellspacing="0" cellpadding="0" border="0">
<thead>
<tr><th class="left">Current Order</th></tr>
</thead>
</table>
<table width="100%" cellspacing="0" cellpadding="0" border="0">
<tbody>');
declare
    c number := 0; t number := 0;
begin
-- loop over cart values
for c1 in (select c001 pid, c002 i, to_number(c003) p, count(c002) q, sum(c003) ep,  'Remove' remove
from apex_collections
where collection_name = 'ORDER'
group by c001, c002, c003
order by c002)
loop
sys.htp.p('<div class="CartItem">
<a href="'||apex_util.prepare_url('f?p=&APP_ID.:12:&SESSION.:REMOVE:::P12_PRODUCT_ID:'||sys.htf.escape_sc(c1.pid))||'"><img src="#IMAGE_PREFIX#delete.gif" alt="Remove from cart" title="Remove from cart" /></a>&nbsp;&nbsp;
'||sys.htf.escape_sc(c1.i)||'
<span>'||trim(to_char(c1.p,'$999G999G999D00'))||'</span>
<span>Quantity: '||c1.q||'</span>
<span class="subtotal">Subtotal: '||trim(to_char(c1.ep,'$999G999G999D00'))||'</span>
</div>');
c := c + 1;
t := t + c1.ep;
end loop;
sys.htp.p('</tbody></table>');
if c > 0 then
    sys.htp.p('<div class="CartTotal">
    <p>Items: <span>'||c||'</span></p>
    <p class="CartTotal">Total: <span>'||trim(to_char(t,'$999G999G999D00'))||'</span></p>
    </div>');
else
   sys.htp.p('<div class="alertMessage info" style="margin-top: 8px;">');
     sys.htp.p('<img src="#IMAGE_PREFIX#f_spacer.gif">');
     sys.htp.p('<div class="innerMessage">');
       sys.htp.p('<h3>Note</h3>');
       sys.htp.p('<p>You have no items in your current order.</p>');
     sys.htp.p('</div>');
   sys.htp.p('</div>');
end if;
end;
sys.htp.p('</div>');
end;
