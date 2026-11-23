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
