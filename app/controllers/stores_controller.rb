class StoresController < ApplicationController
  def show
    @store = current_user.store
    orders = @store.tailor_orders.includes(:items).includes(:alterations)

    @assigned_orders = orders.assigned.on_time
    @new_orders = @assigned_orders.where(arrived: false)
    @active_orders = @assigned_orders.active
    @archived_orders = @assigned_orders.where(fulfilled: true)
    
    @late_orders = orders.late
    @unassigned_orders = orders.needs_assigned

    @welcome_kits = @store.welcome_kits.active
  end
end
