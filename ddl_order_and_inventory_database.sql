create table wholesaler (
    wholesaler_id int primary key
    , wholesaler_name varchar(100) not null
)

create table purchase_order(
    order_id int primary key
    , wholesaler_id int not null
    , delivery_date date
    , status 
    , wholesaler_id int references wholesaler(wholesaler_id)
    , warehouse_id int references warehosue(warehouse_id)
    , amount_paid
)

create table freight_carrier(
    company_id int primary key
    , company_name varchar(100)
)

freight_carrier_payment(
    payment_id int primary key
    , 
    , 
    , 
)

create table truck(
    truck_id int primary key
    , 
)

create table wholesaler_shipment(
    shipment_id int primary key
    , 
    , 
    , 
    , 
    , 
    , 
)

create table product(
    name varchar(100)
    , 
    , 
    , 
    , 
    , 
    , 
)

create table wholesaler_price(
    wholesaler_id int references wholesaler(wholesaler_id)
    , 
    , 
)

create table item(
    item_id int primary key
    , 
    , 
    , 
    , 
    , 
    , 
    , 
    , 
)

create table warehouse(
    warehouse_id int primary key
    , 
    , 
    , 
    , 
    , 
    , 
    , 
)

create table transfer(
    warehouse_id int references warehouse(warehouse_id)
    , 
    , 
    , 
)

create table shop(
    shop_id int primary key
    , 
    , 
    , 
    , 
    , 
    , 
)

create table customer_visit(
    shop_id int references shop(shop_id)
    , 
    , 
    , 
)

create table small_parcel_carrier(
    company_name varchar(100)
    , 
)

create table small_parcel_vehicle(
    vehicle_id int primary key
    , 
)

create table customer_shipment(
    shipment_id int primary key
    , 
    , 
    , 
    , 
)

create table customer(
    name varchar(100)
    , 
    , 
    , 
    , 
)

create table customer_order(
    order_id int primary key
    , 
    , 
    , 
    , 
    , 
)















