class Api::CompaniesController < ApplicationController
  before_action :authenticate_user!

  def index
    render :json => Company.all.as_json #current_user.store.open_orders.as_json(include: [:customer], methods: [:alterations_count])
  end
end
