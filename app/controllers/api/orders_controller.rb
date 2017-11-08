class Api::OrdersController < ApplicationController
  before_action :authenticate_user!, except: [:new, :create, :edit, :update]
  before_action :set_order, only: [:show, :update]

  def index
    if current_user.admin?
      store = Store.find(params[:store_id])
    else
      store = current_user.store
    end

    render :json => store.open_orders.as_json(include: [:customer], methods: [:alterations_count])
  end

  def show
    data = @order.as_json(include: [:incoming_shipment, :outgoing_shipment, :customer , :items => {include: [:item_type, :alterations]}])
    render :json => data
  end

  def new_orders
    unassigned = TailorOrder.all.where(tailor: nil).as_json(include: [:incoming_shipment, :outgoing_shipment, :customer , :items => {include: [:item_type, :alterations]}])
    welcome_kits = WelcomeKit.all.where(fulfilled: false).as_json(include: [:incoming_shipment, :outgoing_shipment, :customer , :items => {include: [:item_type, :alterations]}])
    data = {unassigned: unassigned, welcome_kits: welcome_kits}
    render :json => data
  end

  def update
    if @order.update(order_params)
      render :json => @order.as_json(include: [:customer, :incoming_shipment, :outgoing_shipment, :items => {include: [:item_type, :alterations]}])
    else
      byebug
    end
  end

  def create
    begin
      @order = Order.new(order_params)
      if @order.init && @order.save
        garments = params[:order][:garments]
        Item.create_items_portal(@order, garments)
        render :json => @order.as_json(include: [:customer, :retailer, :items => {include: [:item_type, :alterations]}])
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
    results = Order.joins(:customer).advanced_search(
      {
        id: query,
        customers: {
          first_name: query,
          last_name: query
        }
      }, false).select {|order| (order.retailer == store || order.tailor == store || current_user.admin?) }
    render :json => results.sort_by {|h| h[:created_at]}.reverse.as_json(include: [:customer], methods: [:alterations_count])
  end

  def archived
    if current_user.admin?
      data = TailorOrder.all.archived.order(:fulfilled_date).reverse.as_json(include: [:tailor, :retailer, :customer])
    else
      data = current_user.store.orders.archived.order(:fulfilled_date).reverse.as_json(include: [:customer], methods: [:alterations_count])
    end
    render :json => data
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order)
      .permit(
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
