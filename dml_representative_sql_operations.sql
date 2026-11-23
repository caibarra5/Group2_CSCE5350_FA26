-- 1. find all individual items associated with a customer order.
select i.item_id, p.product_id, p.name, i.status
from customer_shipment as cs
join item as i
    on i.customer_shipment_id = cs.shipment_id
join product as p
    on p.product_id = i.product_id
where cs.customer_order_id = 1;


-- 2. find the shipment associated with a customer order.
select *
from customer_shipment
where customer_order_id = 1;


-- 3. find all trucks belonging to a freight carrier company.
select fc.company_name, t.truck_id
from freight_carrier as fc
join truck as t
    on t.company_id = fc.company_id
where fc.company_id = 1;


-- 4. find all vehicles belonging to a small parcel carrier company.
select spc.company_name, spv.vehicle_id
from small_parcel_carrier as spc
join small_parcel_vehicle as spv
    on spv.company_id = spc.company_id
where spc.company_id = 1;


-- 5. check whether an item has a recorded transfer to a shop,
--    and show the destination and date when available.
select
    i.item_id,
    case
        when tr.transfer_id is null then 'no recorded transfer'
        else 'transfer recorded'
    end as transfer_status,
    s.shop_id,
    s.location_address,
    tr.date_of_transfer
from item as i
left join transfer as tr
    on tr.transfer_id = i.transfer_id
left join shop as s
    on s.shop_id = tr.shop_id
where i.item_id = 1;


-- 6. list products offered by a particular wholesaler.
select p.product_id, p.name, wp.wholesaler_price_per_unit
from wholesaler_price as wp
join product as p
    on p.product_id = wp.product_id
where wp.wholesaler_id = 1;


-- 7. compare the wholesaler prices of a particular product.
select w.wholesaler_id, w.wholesaler_name,
       wp.wholesaler_price_per_unit
from wholesaler_price as wp
join wholesaler as w
    on w.wholesaler_id = wp.wholesaler_id
where wp.product_id = 1
order by wp.wholesaler_price_per_unit;


-- 8. estimate gross profit for a customer order.

with order_item_prices as (
    select
        cs.customer_order_id,
        p.retail_price,
        wp.wholesaler_price_per_unit
    from customer_shipment as cs
    join item as i
        on i.customer_shipment_id = cs.shipment_id
    join product as p
        on p.product_id = i.product_id
    left join purchase_order as po
        on po.order_id = i.purchase_order_id
    left join wholesaler_price as wp
        on wp.product_id = i.product_id
       and wp.wholesaler_id = po.wholesaler_id
    where cs.customer_order_id = 1
)
select
    customer_order_id,
    count(*) as item_count,
    case
        when count(retail_price) = count(*)
         and count(wholesaler_price_per_unit) = count(*)
        then sum(retail_price - wholesaler_price_per_unit)
        else null
    end as estimated_gross_profit
from order_item_prices
group by customer_order_id;


-- 9. list shipments assigned to a small parcel vehicle.
select shipment_id, customer_order_id, warehouse_id, customer_id
from customer_shipment
where carrier_vehicle_id = 1;

-- 1. insert new business partners and a customer.

insert into wholesaler (wholesaler_id, wholesaler_name)
values (101, 'automotive supply company');

insert into freight_carrier (company_id, company_name)
values (101, 'regional freight company');

insert into small_parcel_carrier (company_id, company_name)
values (101, 'local parcel company');

insert into customer (
    customer_id, name, customer_type, address, apt_number
)
values (
    101, 'alex smith', 'individual', '123 main street', null
);


-- 2. insert new vehicles belonging to those companies.

insert into truck (truck_id, company_id)
values (101, 101);

insert into small_parcel_vehicle (vehicle_id, company_id)
values (101, 101);


-- 3. insert a new product and its wholesaler price.

insert into product (
    product_id, name, category, sub_category,
    retail_price, recall, recall_id
)
values (
    101, 'socket wrench set', 'repair tools', 'hand tools',
    49.99, false, null
);

insert into wholesaler_price (
    product_id, wholesaler_id, wholesaler_price_per_unit
)
values (101, 101, 30.00);


-- 4. insert several individual items in one statement.

insert into item (
    item_id, product_id, purchase_order_id, warehouse_id, status
)
values
    (1001, 101, 1, 1, 'in warehouse'),
    (1002, 101, 1, 1, 'in warehouse'),
    (1003, 101, 1, 1, 'in warehouse');


-- 5. update a product's retail price.

update product
set retail_price = 54.99
where product_id = 101;


-- 6. update the price charged by a particular wholesaler.

update wholesaler_price
set wholesaler_price_per_unit = 32.00
where product_id = 101
  and wholesaler_id = 101;


-- 7. correct a recorded freight carrier payment.

update freight_carrier_payment
set amount_paid = 275.00
where payment_id = 1;


-- 8. update an item after its transfer to a shop.

update item
set warehouse_id = null,
    shop_id = 1,
    transfer_id = 1,
    status = 'in shop'
where item_id = 1001;


-- 9. update an item when it leaves for a customer.

update item
set warehouse_id = null,
    shop_id = null,
    customer_shipment_id = 1,
    status = 'in transit'
where item_id = 1002;


-- 10. demonstrate deleting an incorrectly entered record.
-- use an unused id. I inserted a new record to delete and rollback to avoid changin
-- the database.

begin;

insert into wholesaler (wholesaler_id, wholesaler_name)
values (99999, 'incorrect test entry');

delete from wholesaler
where wholesaler_id = 99999;

rollback;