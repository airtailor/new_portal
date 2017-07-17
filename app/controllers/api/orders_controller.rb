class Api::OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_order, only: [:show, :update]

  def index
    render :json => current_user.store.open_orders.as_json(include: [:customer], methods: [:alterations_count])
  end

  def show
    render :json => @order.as_json(include: [:customer, :items => {include: :item_type}])
  end

  def update
    if @order.update(order_params)
      render :json => @order
      .as_json(include: [:customer, :items => {include: :item_type}])
    else
      byebug
    end
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    if current_user.tailor?
      params.require(order).permit(:requester_notes, :arrived, :fulfilled)
    end
  end

end
