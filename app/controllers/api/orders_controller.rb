class Api::OrdersController < ApplicationController
  before_action :authenticate_user!, except: [:new, :create, :edit, :update]
  before_action :set_order, only: [:show, :update]

  def index
    render :json => current_user.store.open_orders.as_json(include: [:customer], methods: [:alterations_count])
  end

  def show
    data = @order.as_json(include: [:incoming_shipment, :outgoing_shipment, :customer, :items => {include: [:item_type, :alterations]}])

    render :json => data   
  end

  def update
    if @order.update(order_params)
      render :json => @order
      .as_json(include: [:customer, :items => {include: [:item_type, :alterations]}])
    else
      byebug
    end
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    #if current_user.tailor?
      params.require(:order)
        .permit(
          :provider_notes, :arrived, :fulfilled, :provider_id, :weight)
    #end
  end

end
