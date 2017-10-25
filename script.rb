class DataInserter
  attr_accessor :customers, :orders, :shipments, :measurements
  def initialize(data)
    @customers = data['customers']
    @orders = data['orders']
    @shipments = data['shipments']
    @measurements = data['measurements']
  end

  def insert_customers
    cust_count = Customer.count
    @customers.each do |customer|
      cust = Customer.create(customer)
      if cust.save
        # poop
        #puts cust.first_name
      else
        #other hting
      end
    end
  end

  def reject_dummy_orders
    @orders = @orders.reject! do |order|
      val = (
        order["name"] == "Ariel Avila" ||
        order["name"] == "Joshua Brueckner" ||
        order["name"] == "Brian Flynn" ||
        order["name"] == "Sam Tilin" ||
        order["name"] == "Kyong Shik Choo" ||
        order["name"] == "John Lesley Morton" ||
        order["name"] == "Todd Harrison Calvert" ||
        order["name"] == "Eric Hall" ||
        order["name"] == "John Kelly Jr" ||
        order["name"] == "Ian Benjamin" ||
        order["name"] == "Fon N" ||
        order["name"] == "Joseph Reed"
      ) ||
      (
        !get_customer order
      )

      # if val
      #   #puts order["name"]
      # end
      val

      #  if !get_customer order
      #    puts order["name"]
      #    return true
      #  end
       #
      #  false
    end
  end

  def insert_orders
    order_count = Customer.count
    @orders.each do |order|
      customer = get_customer(order)
      order['customer_id'] = customer.id
      puts customer
      order.delete('name')
      alts = eval(order['alterations'])

      # binding.pry if order["type"] != "WelcomeKit"
      order.delete('alterations')
      new_order = Order.create(order)
      insert_alterations(alts, new_order)
    end
  end

  def make_alts_into_array alts
    alts = alts.values
  end

  def get_customer(order)
    first_name, *last_name = order["name"].split(" ")
    last_name = last_name.map(&:capitalize).join(" ")
    if last_name.include? "Jr Jr"
      last_name = last_name.gsub("Jr Jr", "Jr")
    end
    # puts first_name; puts last_name
    # first_name = order['name'].split(' ')[0]
    # last_name = order['name'].split(' ').unshift.join

    customers = Customer.where(first_name: first_name, last_name: last_name)
    if customers.empty?
      #puts "#{first_name} #{last_name}"
    end
    customers.first
  end

  def insert_alterations(alts, order)
    if order["type"] == "TailorOrder"
      alts = make_alts_into_array(alts)
      Item.create_items_portal(order, alts)
    end
  end

  def insert_measurements
    @measurements = @measurements.map do |meas|
      customers = Customer.where(first_name: meas["customer_name"].split.first).where(last_name: meas["customer_name"].split.last)
      if !customers.empty?
        meas["customer_id"] = customers.first.id
        #Meabinding.pry if meas["customer_id"].nil?
        meas.delete("customer_name")
        new_meas = Measurement.create(meas)
        if new_meas.save
          puts "yes"
        else
          binding.pry
        end
    else
    puts meas["customer_name"]
    end
    end
  end

  def get_meas_customer meas
    first_name = meas["customer_name"].split.first
    last_name = meas["customer_name"].split.last
    customers = Customer.where(first_name: first_name, last_name: last_name)
    if !customers.empty?
      "#{first_name} #{last_name}"
    end
    customers.first
  end

  def reject_dummy_measurements
    @measurements = @measurements.reject! do |meas|
      val = (
        meas["name"] == "Ariel Avila" ||
        meas["name"] == "Joshua Brueckner" ||
        meas["name"] == "Brian Flynn" ||
        meas["name"] == "Sam Tilin" ||
        meas["name"] == "Kyong Shik Choo" ||
        meas["name"] == "John Lesley Morton" ||
        meas["name"] == "Todd Harrison Calvert" ||
        meas["name"] == "Eric Hall" ||
        meas["name"] == "John Kelly Jr" ||
        meas["name"] == "Ian Benjamin" ||
        meas["name"] == "Fon N" ||
        meas["name"] == "Joseph Reed"
      ) ||
      (
        !get_meas_customer meas
      )

      val
    end
  end
end

require 'json'
require 'pry'

FILE_PATH = '/Users/jared/code/airtailor/airtailorportal/orders.rb'.freeze

data = nil
File.open(FILE_PATH) do |f|
  data = f.read
end

insert = DataInserter.new JSON.parse(data)
insert.insert_customers
insert.reject_dummy_orders

insert.orders.reject!{|x| x["name"] == "Kyong Shik Choo"}

insert.insert_orders
insert.reject_dummy_measurements
insert.insert_measurements
#insert.insert_alterations
binding.pry
