
select customer_id, cust_first_name||' '||cust_last_name customer_name,
cust_street_address1, cust_city, cust_state, cust_postal_code, cust_email,
phone_number1, url, credit_limit, tags
from DEMO_CUSTOMERS