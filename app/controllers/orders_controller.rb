class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :update]

  def show
  end

  def update
    if @order.update(order_params)
      redirect_to store_order_path(current_user.store, @order), notice: "Order successfully updated"
    else
      redirect_to store_order_path(current_user.store, @order), alert: "Oops something went wrong"
    end
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    if current_user.tailor?
      params.require(params[:type].to_sym).permit(:provider_notes, :arrived, :fulfilled)
    elsif current_user.admin?
      params.require(params[:type].to_sym).permit(:requester_notes, :provider_id, :arrived, :fulfilled)
    end
  end
end