create table wholesaler (
    wholesaler_id int primary key
    , wholesaler_name varchar(100) not null
);

create table warehouse(
    warehouse_id int primary key
    , location_address varchar(100)
    , storage_utilization_rate decimal(3,2)
    , manager_name varchar(100) not null
    , warehouse_specialization varchar(100)
    , date_lease_start date
    , date_lease_end date
    , status varchar(100)
);

create table purchase_order(
    order_id int primary key
    , date_order_placed date not null
    , delivery_date date
    , status varchar(50) not null
             check (status in ('sent', 'in transit', 'arrived', 'aborted', 'failed') )
    , wholesaler_id int not null references wholesaler(wholesaler_id)
    , warehouse_id int not null references warehouse(warehouse_id)
    , amount_paid decimal(8,2)
);

create table freight_carrier(
    company_id int primary key
    , company_name varchar(100)
);

create table freight_carrier_payment(
    payment_id int primary key
    , warehouse_id int not null references warehouse(warehouse_id)
    , company_id int not null references freight_carrier(company_id)
    , amount_paid decimal(8,2)
);

create table truck(
    truck_id int primary key
    , company_id int not null references freight_carrier(company_id)
);

create table wholesaler_shipment(
    shipment_id int primary key
    , order_id int not null references purchase_order(order_id)
    , status varchar(50) not null
             check (status in ('sent', 'in transit', 'arrived', 'aborted', 'failed') )
    , wholesaler_id int not null references wholesaler(wholesaler_id) 
    , warehouse_id int not null references warehouse(warehouse_id)
    , pickup_address varchar(100) not null
    , arrival_date date
    , constraint uq_order_id UNIQUE (order_id)
    , truck_id int not null references truck(truck_id) -- very important, forgot it.
);

create table product(
    name varchar(100)
    , product_id int primary key
    , category varchar(100)
    , sub_category varchar(100)
    , retail_price decimal(7,2)
    , recall boolean
    , recall_id int
);

create table wholesaler_price(
    wholesaler_id int not null references wholesaler(wholesaler_id)
    , product_id int not null references product(product_id)
    , wholesaler_price_per_unit decimal(7,2)
    , primary key (wholesaler_id, product_id)
);

create table shop(
    shop_id int primary key
    , location_address varchar(100)
    , manager_name varchar(100)
    , manager_id int
    , building_lease_start_date date
    , building_lease_end_date date
    , status varchar(100)
);

create table customer(
    name varchar(100)
    , customer_id int primary key
    , customer_type varchar(100)
    , address varchar(100)
    , apt_number int
);

create table small_parcel_carrier(
    company_name varchar(100)
    , company_id int primary key
);

create table small_parcel_vehicle(
    vehicle_id int primary key
    , company_id int not null references small_parcel_carrier(company_id)
);

create table customer_order(
    order_id int primary key
    , date_order_placed date
    , delivery_date date
    , status varchar(100)
    , warehouse_id int references warehouse(warehouse_id)
    , customer_id int not null references customer(customer_id)
);

create table customer_shipment(
    shipment_id int primary key
    , customer_order_id int not null references customer_order(order_id)
    , constraint uq_customer_order_id UNIQUE (customer_order_id)
    , customer_id int not null references customer(customer_id) 
    , carrier_vehicle_id int references small_parcel_vehicle(vehicle_id)
    , warehouse_id int references warehouse(warehouse_id)
);

create table transfer(
    warehouse_id int not null references warehouse(warehouse_id)
    , shop_id int not null references shop(shop_id)
    , date_of_transfer date not null
    , transfer_id int primary key
);

create table item(
    item_id int primary key
    , product_id int not null references product(product_id)
    , bulk_id int
    , shop_id int references shop(shop_id)
    , purchase_order_id int not null references purchase_order(order_id)
    , warehouse_id int references warehouse(warehouse_id)
    , status varchar(100)
    , customer_shipment_id int references customer_shipment(shipment_id)
    , transfer_id int references transfer(transfer_id)
);

create table customer_visit(
    shop_id int not null references shop(shop_id)
    , customer_id int not null references customer(customer_id)
    , date_and_time_visit date not null
    , customer_order_id int not null references customer_order(order_id)
    , primary key (shop_id, customer_id, date_and_time_visit)
);

