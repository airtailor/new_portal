class Api::OrdersController < ApplicationController
  before_action :authenticate_user!, except: [:new, :create, :edit, :update]

  def index
    if current_user.admin?
      @store = Store.find(params[:store_id])
    else
      @store = current_user.store
    end
    sql_includes = [ :tailor, :retailer, :customer, :shipments ]
    render :json => @store.open_orders.includes(*sql_includes)
                      .as_json(
                        include: [ :tailor, :retailer, :customer, :shipments ],
                        methods: [ :alterations_count ]
                      )
  end

  def show
    @order = Order.where(id: params[:id])
    # add @shipments in
    sql_includes = [
      :tailor, :retailer, :customer,
      shipments: [ :source, :destination ],
      items: [ :item_type, :alterations ]
    ]
    data = @order.includes(*sql_includes).as_json(include: [
            :tailor,
            :retailer,
            :customer,
            shipments: { include: [ :source, :destination ]},
            items: { include: [ :item_type, :alterations ]}
          ]).first
    render :json => data
  end

  def new_orders
    sql_include = [ :shipments, :customer, items: [ :item_type, :alterations ] ]
    tailor_orders = TailorOrder.where(tailor: nil).includes(*sql_include)
    welcome_kits = WelcomeKit.where(fulfilled: false).includes(*sql_include)
    @data = {
      unassigned: tailor_orders.as_json( include: [
        :shipments, :customer, :items => { include: [ :item_type, :alterations ] }
      ]),
      welcome_kits: welcome_kits.as_json( include: [
        :shipments, :customer, :items => { include: [ :item_type, :alterations ] }
      ])
    }

    render :json => @data
  end

  def update
    @order = Order.where(id: params[:id])
    if @order.first.update(order_params)
      sql_includes = [
        :tailor, :retailer, :customer,
        shipments: [ :source, :destination ],
        items: [ :item_type, :alterations ]
      ]
      data =  @order.includes(*sql_includes).as_json(
                include: [
                  :tailor, :retailer, :customer,
                  shipments: { include: [ :source, :destination ]},
                  items:  { include: [ :item_type, :alterations ] },
                ]).first
      render :json => data
    else
      byebug
    end
  end

  def create
    begin
      @order = Order.new(order_params)
      @order.set_default_fields

      if @order.save
        garments = params[:order][:garments]
        Item.create_items_portal(@order, garments)
        sql_includes = [
          :tailor, :retailer, :customer,
          items: [ :item_type, :alterations ]
        ]
        render :json => @order.includes(*sql_includes).as_json(include: [
          :tailor,
          :retailer,
          :customer,
          :items => {
            include: [ :item_type, :alterations ]
          }
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
    end
  end

  def search
    query = params[:query]
    store = current_user.store
    results = Order.joins(:customer).order(created_at: :desc).advanced_search(
      {
        id: query,
        customers: {
          first_name: query,
          last_name: query
        }
      }, false).select { |order|
        (order.retailer == store || order.tailor == store || current_user.admin?)
      }

    render :json => results.as_json(include: [:customer], methods: [:alterations_count])
  end

  def archived
    if current_user.admin?
      data = Order.includes(:tailor, :retailer).archived.order(:fulfilled_date).reverse
              .as_json(include: [:tailor, :retailer])
    else
      data = current_user.store.orders.includes(:customer).archived.order(:fulfilled_date).reverse
              .as_json(include: [:customer], methods: [:alterations_count])
    end
    render :json => data
  end

  private

  def order_params
    params.require(:order).permit(
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
        :ship_to_store
      )
  end

end
