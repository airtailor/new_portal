# declare order
order = Order.find(72)

# set new items
items = [{:title => "Pants", :alterations => [{:title => "Repair Button"}]}]

# add items to order
Item.create_items_portal(order, items)

# check order items & alterations
order = Order.find(72)
order.items
order.items.last.alterations

# update order weight
new_weight = order.weight + 680
order.update_attributes(weight: new_weight)

# update order notes
#
