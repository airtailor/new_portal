class Api::TailorsController < ApplicationController
  before_action :authenticate_user!

  def index
    data = Tailor.all.as_json(methods: [
      :active_orders_count,
      :arrived_orders_count,
      :late_orders_count
    ])
    render :json => data
  end
end
