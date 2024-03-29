class Api::OrdersController < ApplicationController
  before_action :authenticate_user!, except: [:new, :create, :edit, :update, :alert_customers, :customer_pickup]
  before_action :set_order, only: [:show, :update]

  def index
    sql_includes = [ :tailor, :retailer, :customer, :shipments, :items, :alterations   ]
    user_roles = current_user.roles

    if user_roles.first.name == "admin"
      store = Store.where(id: params[:store_id]).first
      @data = store.open_orders
    elsif user_roles.first.name == "tailor"
      store = Store.where(id: current_user.store.id).first
      @data = store.open_orders
    elsif user_roles.first.name == "retailer"
      store = Store.where(id: current_user.store.id).first
      @data = store.retailer_orders
    end

    if @data
      render :json => @data.includes(*sql_includes).as_json(
                        include: sql_includes, methods: [ :alterations_count ]
                      )
    else
      render :json => {errors: @data.errors}
    end
  end

  def show
    sql_includes = [
      :tailor, retailer: [ :address ], customer: [ :addresses ],
      shipments: [ :source, :destination ],
      items: [ :item_type, :alterations ]
    ]

    data = @order_relation.includes(*sql_includes)
    items = data.first.items.as_json(include: [ :item_type, :alterations ])
    shipments = data.first.shipments.as_json(include: [ :source, :destination ])

    if data.first.ship_to_store
      render :json => data.as_json(include: [
        :tailor, :customer, retailer: { include: [ :address ] }
      ]).first.merge("items" => items, "shipments" => shipments)
    else
      render :json => data.as_json(include: [
        :tailor, :retailer, customer: { include: [ :addresses ] }
      ]).first.merge("items" => items, "shipments" => shipments)
    end
  end

  def new_orders
    sql_includes = [ :shipments, :customer, items: [ :item_type, :alterations ] ]
    @data = {
      unassigned: TailorOrder.where(tailor: nil).includes(*sql_includes).as_json(
        include: [
          :shipments, :customer, :items => { include: [ :item_type, :alterations ]}
      ]),
      welcome_kits: WelcomeKit.fulfilled(false).includes(*sql_includes).as_json(
        include: [
          :shipments, :customer, :items => { include: [ :item_type, :alterations ]}
      ])
    }

    render :json => @data
  end

  def update

    if @order_object
      tailor_assigned = @order_object.tailor.present?
      @already_arrived = @order_object.arrived
    end

    @order_object.assign_attributes(order_params)
    @order_object.parse_order_lifecycle_stage

    if @order_object.save
      @order_object.queue_customer_for_delighted

      if params[:order][:provider_id] && !tailor_assigned
        @order_object.send_shipping_label_email_to_customer
      end

      if customer_should_get_arrived_text?
        @order_object.text_customer_order_arrived_at_tailor
      end

      sql_includes = [
        :tailor, :retailer, :customer, :items, :item_types, :alterations,
        shipments: [ :source, :destination ]
      ]
      data =  @order_relation.includes(*sql_includes)
      items = data.first.items.as_json(include: [ :item_type, :alterations ])
      render :json => data.as_json(
                include: [
                  :tailor, :retailer, :customer,
                  shipments: { include: [ :source, :destination ]},
                ]).first.merge('items' => items)
    else
      render :json => {errors: @order_object.errors}
    end
  end

  def create
    begin
      @order = Order.new(order_params)

      @order.set_order_defaults
      @order.parse_order_lifecycle_stage

      if @order.save
        Item.create_items_portal(@order, params[:order][:garments])
        @order.send_order_confirmation_text

        if @order.source == "Shopify"
          @rder.update_attributes(:provider_id => nil)
        end

        sql_includes = [
          :tailor, :retailer, :customer,
          shipments: [ :source, :destination ],
          items: [ :item_type, :alterations ]
        ]

        data = Order.where(id: @order.id).includes(*sql_includes)
        items = data.first.items.as_json(include: [ :item_type, :alterations ])

        render :json => data.as_json(include: [
            :tailor, :retailer, :customer
          ]).first.merge("items" => items)
      else
        render :json => {errors: @order.errors.full_messages}
      end
     rescue => e
       if e.message.include?("Invalid Phone Number")
         render :json => {errors: ["Invalid Phone Number"]}
       else
         render :json => {errors: e}
       end
    end
  end

  def search
    query = params[:query]
    store = current_user.store

    results = Order.includes(:customer).joins(:customer).order(created_at: :desc)
      .advanced_search(
        {
          id: query, customers: { first_name: query, last_name: query, first_name: query.split.first, last_name: query.split.last }
        }, false).select { |order|
          (order.retailer == store || order.tailor == store || current_user.admin?)
        }

    render :json => results.as_json(include: [:customer], methods: [:alterations_count])
  end

  def archived
    if current_user.admin?
      data = TailorOrder.includes(:tailor, :retailer, :customer).fulfilled(true)
              .order(fulfilled_date: :desc).first(100)
              .as_json(include: [:tailor, :retailer, :customer])
    else
      data = current_user.store.orders.includes(:customer).fulfilled(true)
              .order(fulfilled_date: :desc).first(100)
              .as_json(include: [:customer], methods: [:alterations_count])
    end

    render :json => data.as_json(include: [:tailor, :retailer, :customer])
  end

  def alert_customers
    orders = Order.where(id: params[:orders])
    orders.map(&:alert_customer_order_ready_for_pickup)
    orders.update_all(customer_alerted: true)
    render :json => {status: 200}
  end

  def customer_pickup
    orders = Order.where(id: params[:orders])
    orders.update_all(customer_picked_up: true)
    render :json => {status: 200}
  end

  # def order_data
  #   @orders = Order.all
  #   @current_year = Date.current.year
  #   @current_month = Date.current.month
  #   @orders_this_month = @year.where('extract(month from created_at) = ? and extract(year from created_at) = ?', @current_month, @current_year)
  #   @orders_this_year = @orders.where("created_at >= ?", @current_year + "-01-01").all
  # end

  private

  def customer_should_get_arrived_text?
    params[:order][:arrived] &&
      !@already_arrived &&
      @order_object.type == "TailorOrder" &&
      @order_object.retailer == Retailer.first
  end

  def set_order
    @order_relation = Order.where(id: params[:id])
    @order_object = @order_relation.first
  end

  def order_params
    params.require(:order).permit(
        :id,
        :provider_notes,
        :requester_notes,
        :arrived,
        :fulfilled,
        :provider_id,
        :weight,
        :requester_id,
        :total,
        :type,
        :customer_id,
        :source,
        :items,
        :ship_to_store
      )
  end

end
