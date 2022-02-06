/*7. Write a query to display carton id, (len*width*height) as carton_vol and 
identify the optimum carton (carton with the least volume whose volume is greater than the total volume of all items 
(len * width * height * product_quantity)) for a given order whose order id is 10006, 
Assume all items of an order are packed into one single carton (box). (1 ROW)*/

select c.carton_id,(c.LEN*c.WIDTH*c.HEIGHT) as CARTON_VOL  from carton  c
having CARTON_VOL>(select max(Total_vol)  from
( select sum(p.LEN*p.width*p.height*o.product_quantity) as Total_vol
from product p left join order_items o  on p.product_id=o.product_id and o.order_id = '10006')a)
order by CARTON_VOL desc limit 1;
 -----------------------------------------------------------------------------------------------------------------------------------
 /*8.Write a query to display details (customer id,customer fullname,order id,product quantity)
 of customers who bought more than ten (i.e. total order qty) products per shipped order.
 (11 ROWS) [NOTE: TABLES TO BE USED - online_customer, order_header, order_items,]*/
 
 select 
 oc.Customer_id,
 concat(oc.CUSTOMER_FNAME,' ',oc.CUSTOMER_LNAME) as Customer_Name,
 oh.Order_id,
 sum(o.product_quantity) as Total_Quantity
 from online_customer oc 
 left join order_header oh on oh.customer_id=oc.customer_id 
 left join order_items o on o.order_id=oh.order_id
 where oh.order_status ='Shipped'
 group by oh.order_id
 having sum( o.product_quantity)>10;
 -----------------------------------------------------------------------------------------------------
 /*9.Write a query to display the order_id, customer id and cutomer full name of customers along with (product_quantity) as total quantity of products
 shipped for order ids > 10060.  (6 ROWS) [NOTE: TABLES TO BE USED - online_customer, order_header, order_items]*/
 
 select 
 oh.Order_id,
 oc.Customer_id,
 concat(oc.CUSTOMER_FNAME,' ',oc.CUSTOMER_LNAME) as Customer_Name, 
 sum(o.product_quantity) as Total_Quantity
 from online_customer oc 
 inner join order_header oh on oh.customer_id=oc.customer_id 
 inner join order_items o on o.order_id=oh.order_id
 where oh.order_status ='Shipped' and oh.order_id>'10060'
 group by Customer_Name
 having sum(o.product_quantity) 
 order by Total_Quantity desc;
 -----------------------------------------------------------------------------------------------------------------------------------------------------
 /*10. Write a query to display product class description ,total quantity (sum(product_quantity),Total value (product_quantity * product price) and 
 show which class of products have been shipped highest(Quantity) to countries outside India other than USA? Also show the total value of those items. 
 (1 ROWS)[NOTE:PRODUCT TABLE,ADDRESS TABLE,ONLINE_CUSTOMER TABLE,ORDER_HEADER TABLE,ORDER_ITEMS TABLE,PRODUCT_CLASS TABLE]*/
 
select pc.product_class_desc,
sum(o.product_quantity) as Total_Quantity,
(p.product_price+o.product_quantity) as Total_Value
from product_class pc
left join product p on p.product_class_code=pc.product_class_code
left join order_items o on  o.product_id=p.product_id
left join order_header oh on oh.order_id=o.order_id
left join online_customer oc on oc.customer_id=oh.customer_id
left join address ad on ad.address_id = oc.address_id
where oh.order_status ='Shipped' and not ad.country='India' and not ad.country='USA' and (select max(o.product_quantity) from order_items o);