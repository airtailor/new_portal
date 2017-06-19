class OrdersController < ApplicationController

  def edit
    @order = Order.find(params[:id])
  end

  def update
    byebug
  end
end
