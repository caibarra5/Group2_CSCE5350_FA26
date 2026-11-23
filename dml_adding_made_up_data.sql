insert into wholesaler (wholesaler_id, wholesaler_name) values
(1, 'wholesaler1'),
(2, 'wholesaler2');

insert into warehouse (warehouse_id, location_address, storage_utilization_rate, manager_name, warehouse_specialization, date_lease_start, date_lease_end, status) values
(1, '100 warehouse1 street', 0.75, 'maria lopez', 'electronics', '2025-01-01', '2030-01-01', 'active'),
(2, '200 warehouse2 street', 0.60, 'james carter', 'household goods', '2025-06-01', '2030-06-01', 'active');

insert into purchase_order (order_id, date_order_placed, delivery_date, status, wholesaler_id, warehouse_id, amount_paid) values
(1, '2026-10-01', '2026-10-05', 'arrived', 1, 1, 1250.00),
(2, '2026-10-03', '2026-10-08', 'arrived', 2, 2, 980.00),
(3, '2026-10-10', '2026-10-15', 'arrived', 1, 2, 760.00);

insert into freight_carrier (company_id, company_name) values
(1, 'freight carrier1'),
(2, 'freight carrier2');

insert into freight_carrier_payment (payment_id, warehouse_id, company_id, amount_paid) values
(1, 1, 1, 450.00),
(2, 2, 2, 520.00);

insert into truck (truck_id, company_id) values
(1, 1),
(2, 2);

insert into wholesaler_shipment (shipment_id, order_id, status, wholesaler_id, warehouse_id, pickup_address, arrival_date) values
(1, 1, 'arrived', 1, 1, '10 wholesaler1 road', '2026-10-05'),
(2, 2, 'arrived', 2, 2, '20 wholesaler2 road', '2026-10-08'),
(3, 3, 'arrived', 1, 2, '10 wholesaler1 road', '2026-10-15');

insert into product (name, product_id, category, sub_category, retail_price, recall, recall_id) values
('product1', 1, 'electronics', 'audio', 25.00, false, null),
('product2', 2, 'electronics', 'audio', 35.00, false, null),
('product3', 3, 'electronics', 'computer accessories', 15.00, false, null),
('product4', 4, 'household goods', 'kitchen', 20.00, false, null),
('product5', 5, 'household goods', 'kitchen', 30.00, false, null),
('product6', 6, 'household goods', 'cleaning', 12.00, false, null),
('product7', 7, 'electronics', 'computer accessories', 45.00, false, null),
('product8', 8, 'electronics', 'audio', 40.00, false, null),
('product9', 9, 'household goods', 'kitchen', 18.00, false, null),
('product10', 10, 'household goods', 'cleaning', 10.00, false, null),
('product11', 11, 'electronics', 'computer accessories', 55.00, false, null),
('product12', 12, 'household goods', 'kitchen', 22.00, false, null),
('product13', 13, 'electronics', 'audio', 28.00, false, null),
('product14', 14, 'household goods', 'cleaning', 14.00, false, null),
('product15', 15, 'electronics', 'computer accessories', 60.00, false, null);

insert into wholesaler_price (wholesaler_id, product_id, wholesaler_price_per_unit) values
(1, 1, 15.00),
(1, 2, 22.00),
(1, 3, 9.00),
(1, 7, 30.00),
(1, 8, 27.00),
(1, 11, 38.00),
(1, 13, 17.00),
(1, 15, 42.00),
(2, 4, 12.00),
(2, 5, 18.00),
(2, 6, 7.00),
(2, 9, 11.00),
(2, 10, 6.00),
(2, 12, 13.00),
(2, 14, 8.00);

insert into shop (shop_id, location_address, manager_name, manager_id, building_lease_start_date, building_lease_end_date, status) values
(1, '300 shop1 street', 'elena ramirez', 101, '2025-01-01', '2030-01-01', 'open'),
(2, '400 shop2 street', 'david kim', 102, '2025-03-01', '2030-03-01', 'open');

insert into customer (name, customer_id, customer_type, address, apt_number) values
('sarah johnson', 1, 'regular', '500 customer street', 2),
('michael brown', 2, 'regular', '600 customer street', 4),
('lisa chen', 3, 'business', '700 customer street', null);

insert into small_parcel_carrier (company_name, company_id) values
('small parcel carrier1', 1),
('small parcel carrier2', 2);

insert into small_parcel_vehicle (vehicle_id, company_id) values
(1, 1),
(2, 2);

insert into customer_order (order_id, date_order_placed, delivery_date, status, warehouse_id, customer_id) values
(1, '2026-10-20', '2026-10-22', 'delivered', 1, 1),
(2, '2026-10-21', '2026-10-23', 'delivered', 2, 2),
(3, '2026-10-22', '2026-10-25', 'in transit', 1, 3);

insert into customer_shipment (shipment_id, customer_order_id, customer_id, carrier_vehicle_id, warehouse_id) values
(1, 1, 1, 1, 1),
(2, 2, 2, 2, 2),
(3, 3, 3, 1, 1);

insert into transfer (warehouse_id, shop_id, date_of_transfer, transfer_id) values
(1, 1, '2026-10-18', 1),
(2, 2, '2026-10-19', 2);

insert into item (item_id, product_id, bulk_id, shop_id, purchase_order_id, warehouse_id, status, customer_shipment_id, transfer_id) values
(1, 1, 1, 1, 1, null, 'sold', 1, null),
(2, 2, 1, 1, 1, null, 'sold', 1, null),
(3, 3, 1, 1, 1, null, 'sold', 1, null),
(4, 4, 2, 2, 2, null, 'sold', 2, null),
(5, 5, 2, 2, 2, null, 'sold', 2, null),
(6, 6, 2, 1, 2, null, 'sold', 3, null),
(7, 7, 1, 1, 1, null, 'sold', 3, null),
(8, 8, null, null, 3, 1, 'in warehouse', null, null),
(9, 9, null, null, 3, 1, 'in warehouse', null, null),
(10, 10, null, null, 3, 1, 'in warehouse', null, null),
(11, 11, null, null, 3, 2, 'in warehouse', null, null),
(12, 12, null, null, 2, 2, 'in warehouse', null, null),
(13, 13, null, null, 1, 1, 'in warehouse', null, null),
(14, 14, null, 1, 2, null, 'in shop', null, 1),
(15, 15, null, 2, 3, null, 'in shop', null, 2);

insert into customer_visit (shop_id, customer_id, date_and_time_visit, customer_order_id) values
(1, 1, '2026-10-20', 1),
(2, 2, '2026-10-21', 2),
(1, 3, '2026-10-22', 3);