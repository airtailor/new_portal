class Api::CompaniesController < ApplicationController
  before_action :authenticate_user!#, except: [:new, :create, :edit, :update]
  #before_action :set_order, only: [:show, :update]

  def index
    render :json => Company.all.as_json #current_user.store.open_orders.as_json(include: [:customer], methods: [:alterations_count])
  end
end
