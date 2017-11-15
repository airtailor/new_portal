class Api::OrdersController < ApplicationController
  before_action :authenticate_user!, except: [:new, :create, :edit, :update]

  def index
    if current_user.admin?
      @store = Store.where(id: params[:store_id]).first
    else
      @store = Store.where(id: current_user.store.id).first
    end

    sql_includes = [ :tailor, :retailer, :customer, :shipments, :items, :alterations   ]
    render :json => @store.open_orders.includes(*sql_includes)
                      .as_json(
                        include: sql_includes, methods: [ :alterations_count ]
                      )
  end

  def show
    @order = Order.where(id: params[:id])
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
    sql_include = [ :shipments, :customer, items: [ :item_type, :alterations ] ]
    @data = {
      unassigned: TailorOrder.where(tailor: nil).includes(*sql_include).as_json( include: [
        :shipments, :customer, :items => { include: [ :item_type, :alterations ] }
      ]),
      welcome_kits: WelcomeKit.fulfilled(false).includes(*sql_include).as_json( include: [
        :shipments, :customer, :items => { include: [ :item_type, :alterations ] }
      ])
    }

    render :json => @data
  end

  def update
    @order = Order.where(id: params[:id])

    @order.first.assign_attributes(order_params)
    @order.first.parse_order_lifecycle_stage
    if @order.first.save
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
      @order.parse_order_lifecycle_stage(order_params)

      if @order.save
        garments = params[:order][:garments]
        Item.create_items_portal(@order, garments)
        sql_includes = [
          :tailor, :retailer, :customer,
          items: [ :item_type, :alterations ]
        ]
        render :json => @order.includes(*sql_includes).as_json(include: [
            :tailor, :retailer, :customer,
            :items => { include: [ :item_type, :alterations ] }
          ])
      else
        render :json => {errors: @order.errors.full_messages}
      end
    rescue => e
      if e.message.include?("Invalid Phone Number")
        render :json => {errors: ["Invalid Phone Number"]}
      else
        render :json => {errors: e}
      end
     rescue => e
       if e.message.include?("Invalid Phone Number")
         render :json => {errors: ["Invalid Phone Number"]}
       else
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
      data = Order.includes(:tailor, :retailer, :customer).fulfilled(true).order(fulfilled_date: :desc)
              .as_json(include: [:tailor, :retailer, :customer])
    else
      data = current_user.store.orders.includes(:customer).fulfilled(true).order(fulfilled_date: :desc)
              .as_json(include: [:customer], methods: [:alterations_count])
    end
    render :json => data
  end

  private

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
