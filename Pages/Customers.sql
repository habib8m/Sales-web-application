
--Customer information--

select CUSTOMER_ID,
       CUST_FIRST_NAME||' '||CUST_LAST_NAME customer_name,
       CUST_STREET_ADDRESS1|| decode(CUST_STREET_ADDRESS2, null, null, ','|| CUST_STREET_ADDRESS2) customer_address,
       CUST_CITY,
       CUST_STATE,
       CUST_POSTAL_CODE
  from DEMO_CUSTOMERS