
-- test recording a new supply purchase from a wholesaler
begin;

  insert into purchase_order (
      order_id, date_order_placed, status, wholesaler_id, warehouse_id
  ) values (
      4, '2026-10-26', 'sent', 1, 1
  );
  
  -- test recording the truck and shipment for the supply purchase
  insert into wholesaler_shipment (
      shipment_id, order_id, status, wholesaler_id,
      warehouse_id, pickup_address, truck_id
  ) values (
      4, 4, 'sent', 1, 1, '10 wholesaler1 road', 1
  );
  
  -- test updating the purchase order and shipment as they travel
  update purchase_order
  set status = 'in transit'
  where order_id = 4;
  
  update wholesaler_shipment
  set status = 'in transit'
  where shipment_id = 4;
  
  -- test recording that the purchase arrived at the warehouse
  update purchase_order
  set status = 'arrived',
      delivery_date = '2026-10-30'
  where order_id = 4;
  
  update wholesaler_shipment
  set status = 'arrived',
      arrival_date = '2026-10-30'
  where shipment_id = 4;

  -- test adding a new individual item to warehouse stock
  insert into item (
      item_id, product_id, purchase_order_id, warehouse_id, status
  ) values (
      16, 1, 4, 1, 'in stock'
  );
  


  -- test recording a customer order and its shipment
  insert into customer_order (
      order_id, date_order_placed, status, warehouse_id, customer_id
  ) values (
      4, '2026-10-31', 'reserved', 1, 1
  );
  
  insert into customer_shipment (
      shipment_id, customer_order_id, customer_id,
      carrier_vehicle_id, warehouse_id
  ) values (
      4, 4, 1, 1, 1
  );
  
  -- test changing an individual item's status to shelved
  update item
  set status = 'shelved',
      shop_id = 1,
      warehouse_id = null
      , customer_shipment_id = 4
  where item_id = 16;
  
  -- test associating the item with a shipment and marking it shipped
  update item
  set status = 'shipped'
    where item_id = 16;
  
  -- test updating the customer order through its delivery stages
  update customer_order
  set status = 'shipped'
  where order_id = 4;
  
  update customer_order
  set status = 'in transit'
  where order_id = 4;
  
  -- test recording a completed sale and delivered order
  update item
  set status = 'sold'
  where item_id = 16;
  
  update customer_order
  set status = 'delivered'
  where order_id = 4;
  
  -- inspect the item, customer order, purchase order, and wholesaler shipment
  select item_id, product_id, status, customer_shipment_id
  from item
  where item_id = 16;
  
  select order_id, status, date_order_placed
  from customer_order
  where order_id = 4;
  
  select order_id, status, delivery_date
  from purchase_order
  where order_id = 4;
  
  select shipment_id, order_id, status, arrival_date
  from wholesaler_shipment
  where shipment_id = 4;
  

  -- test looking up an existing item's product, wholesaler, truck,
  -- small parcel carrier, and customer
  select
      i.item_id,
      p.name as product_name,
      w.wholesaler_name,
      t.truck_id,
      spc.company_name as small_parcel_carrier,
      c.name as customer_name
  from item as i
  join product as p
      on p.product_id = i.product_id
  join purchase_order as po
      on po.order_id = i.purchase_order_id
  join wholesaler as w
      on w.wholesaler_id = po.wholesaler_id
  left join wholesaler_shipment as ws
      on ws.order_id = po.order_id
  left join truck as t
      on t.truck_id = ws.truck_id
  left join customer_shipment as cs
      on cs.shipment_id = i.customer_shipment_id
  left join small_parcel_vehicle as spv
      on spv.vehicle_id = cs.carrier_vehicle_id
  left join small_parcel_carrier as spc
      on spc.company_id = spv.company_id
  left join customer as c
      on c.customer_id = cs.customer_id
  where i.item_id = 16;

    -- undo the test inserts and updates so they do not remain in the database
    rollback;

    
-- edge case 1: move an item from a warehouse to a shop
begin;

  -- create a transfer from warehouse 1 to shop 1
  insert into transfer (
      warehouse_id, shop_id, date_of_transfer, transfer_id
  ) values (
      1, 1, '2026-11-01', 3
  );
  
  -- move item 8 from warehouse 1 to shop 1
  update item
  set warehouse_id = null,
      shop_id = 1,
      status = 'in shop',
      transfer_id = 3
  where item_id = 8;

  update item
  set status = 'lost'
  where item_id = 8;
  
  -- check the item's  location and transfer
  select
      i.item_id,
      i.status,
      i.warehouse_id,
      i.shop_id,
      t.transfer_id,
      t.date_of_transfer
  from item as i
  join transfer as t
      on t.transfer_id = i.transfer_id
  where i.item_id = 8;
  
  rollback;
  
  
  -- edge case 2: record one item as lost in transit from a wholesaler
  begin;
  
  -- create a purchase order and shipment that are still in transit
  insert into purchase_order (
      order_id, date_order_placed, status, wholesaler_id, warehouse_id
  ) values (
      4, '2026-11-02', 'in transit', 1, 1
  );
  
  insert into wholesaler_shipment (
      shipment_id, order_id, status, wholesaler_id,
      warehouse_id, pickup_address, truck_id
  ) values (
      4, 4, 'in transit', 1, 1, '10 wholesaler1 road', 1
  );
  
  -- record item 16 as lost before it reaches the warehouse
  insert into item (
      item_id, product_id, purchase_order_id, warehouse_id, status
  ) values (
      16, 1, 4, null, 'lost in transit'
  );
  
  -- verify the item is recorded as lost while its order and shipment are in transit
  select
      i.item_id,
      p.name as product_name,
      i.status as item_status,
      po.status as purchase_order_status,
      ws.status as shipment_status
  from item as i
  join product as p
      on p.product_id = i.product_id
  join purchase_order as po
      on po.order_id = i.purchase_order_id
  join wholesaler_shipment as ws
      on ws.order_id = po.order_id
  where i.item_id = 16;
  
  rollback;