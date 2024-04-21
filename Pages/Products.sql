
--Products information--

select p.product_id, p.product_name, p.product_description, p.category, 
            decode(p.product_avail, 'Y','Yes','N','No') product_avail, p.list_price,
            (select sum(quantity) from demo_order_items where product_id = p.product_id) units,
            (select sum(quantity * p.list_price) from demo_order_items where product_id = p.product_id) sales,       
            (select count(o.customer_id) from demo_orders o, demo_order_items t 
            where o.order_id = t.order_id and t.product_id = p.product_id group by p.product_id) customers,
            (select max(o.order_timestamp) od from demo_orders o, demo_order_items i where o.order_id = 
            i.order_id and i.product_id = p.product_id) last_date_sold, p.product_id img,
            apex_util.prepare_url(p_url=>'f?p='||:app_id||':6:'||:app_session||
            '::::P6_PRODUCT_ID:'||p.product_id) icon_link,
            decode(nvl(dbms_lob.getlength(p.product_image),0),0,null,
            '<img alt="'||p.product_name||'" title="'||p.product_name||'" style="border: 4px solid #CCC; 
            -moz-border-radius: 4px; -webkit-border-radius: 4px;" '||
            'src="'||apex_util.get_blob_file_src('P6_PRODUCT_IMAGE',p.product_id)||'" height="75"  
            width="75" />') detail_img,
            decode(nvl(dbms_lob.getlength(p.product_image),0),0,null,
            apex_util.get_blob_file_src('P6_PRODUCT_IMAGE',p.product_id)) detail_img_no_style
from  demo_product_info p


--Card view--

select PRODUCT_ID,
       PRODUCT_NAME,
       PRODUCT_DESCRIPTION,
       CATEGORY,
       PRODUCT_AVAIL,
      'Price:'|| LIST_PRICE,
       PRODUCT_IMAGE,
       MIMETYPE,
       FILENAME,
       IMAGE_LAST_UPDATE,
	   Apex_util.get_blob_file_src('P6_PRODUCT_IMAGE', PRODUCT_ID) Image
  from DEMO_PRODUCT_INFO


--Product image (update page)--

declare
begin
  if :P6_PRODUCT_ID is not null then
    for c1 in (select nvl(dbms_lob.getlength(product_image),0) A from demo_product_info where product_id = :P6_PRODUCT_ID)
    loop
       if c1.A > 0 then
          return true;
       end if;
    end loop;
  end if;
  return false;
end;


--Delete image (update page)--

update demo_product_info 
set product_image = null, mimetype = null, filename=null, image_last_update=null
where product_id = :P6_PRODUCT_ID;

