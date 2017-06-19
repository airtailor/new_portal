class StoresController < ApplicationController
  def show
    @store = current_user.store
    orders = @store.orders
    @new_orders = orders.where(arrived: false)
    @active_orders = orders.where(arrived: true, fulfilled: false)
    @archived_orders = orders.where(fulfilled: true)
  end
end
