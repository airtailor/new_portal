class Api::OrdersController < ApplicationController
  before_action :authenticate_user!, except: [:new, :create, :edit, :update, :alert_customers]
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

    render :jason => {errors: @data.errors} if !@data
    
    render :json => @data.includes(*sql_includes).as_json(
                        include: sql_includes, methods: [ :alterations_count ]
                      )
  end

  def show
    sql_includes = [
      :tailor, :retailer, :customer,
      shipments: [ :source, :destination ],
      items: [ :item_type, :alterations ]
    ]

    data = @order.includes(*sql_includes)
    items = data.first.items.as_json(include: [ :item_type, :alterations ])

    render :json => data.as_json(include: [
        :tailor, :retailer, :customer,
        shipments: { include: [ :source, :destination ]}
      ]).first.merge("items" => items)
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
    tailor_assigned = @order.first.tailor.present?

    @order.first.assign_attributes(order_params)
    @order.first.parse_order_lifecycle_stage

    if @order.first.save
      if params[:order][:provider_id] && !tailor_assigned
        @order.first.send_shipping_label_email_to_customer
      end
      @order.first.queue_customer_for_delighted

      sql_includes = [
        :tailor, :retailer, :customer, :items, :item_types, :alterations,
        shipments: [ :source, :destination ]
      ]
      data =  @order.includes(*sql_includes)
      items = data.first.items.as_json(include: [ :item_type, :alterations ])
      render :json => data.as_json(
                include: [
                  :tailor, :retailer, :customer,
                  shipments: { include: [ :source, :destination ]},
                ]).first.merge('items' => items)
    else
      byebug
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
        binding.pry
        render :json => {errors: e}
      end
     rescue => e
       if e.message.include?("Invalid Phone Number")
         render :json => {errors: ["Invalid Phone Number"]}
       else
         binding.pry
         render :json => {errors: e}
       end
    end

    # if @order.errors, render that Here
    # else, do your json
  end

  def search
    query = params[:query]
    store = current_user.store

    results = Order.includes(:customer).joins(:customer).order(created_at: :desc)
      .advanced_search(
        {
          id: query, customers: { first_name: query, last_name: query }
        }, false).select { |order|
          (order.retailer == store || order.tailor == store || current_user.admin?)
        }

    render :json => results.as_json(include: [:customer], methods: [:alterations_count])
  end

  def archived
    if current_user.admin?
      data = Order.includes(:tailor, :retailer, :customer).fulfilled(true).order(fulfilled_date: :desc).first(100)
              .as_json(include: [:tailor, :retailer, :customer])
    else
      data = current_user.store.orders.includes(:customer).fulfilled(true).order(fulfilled_date: :desc).first(100)
              .as_json(include: [:customer], methods: [:alterations_count])
    end
    render :json => data
  end

  def alert_customers
    orders = Order.where(id: params[:orders])
    orders.map(&:alert_customer_order_ready_for_pickup)
    orders.update_all(customer_alerted: true)
    render :json => {status: 200}
  end

  private

  def set_order
    @order = Order.where(id: params[:id])
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
