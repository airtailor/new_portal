class Api::RetailersController < ApplicationController
  before_action :authenticate_user!

  def index
    data = Retailer.all.as_json(methods: [
      :active_orders_count
    ])
    render :json => data
  end
end
