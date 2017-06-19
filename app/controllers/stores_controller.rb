class StoresController < ApplicationController
  def show
    @store = current_user.store
    orders = @store.orders

    @assigned_orders = orders.assigned
    @new_orders = @assigned_orders.where(arrived: false)
    @active_orders = @assigned_orders.where(arrived: true, fulfilled: false)
    @archived_orders = @assigned_orders.where(fulfilled: true)

    @unassigned_orders = orders.needs_assigned
  end
end
