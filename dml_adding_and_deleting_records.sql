
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