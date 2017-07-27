class Api::TailorsController < ApplicationController
  before_action :authenticate_user!#, except: [:new, :create, :edit, :update]
  #before_action :set_order, only: [:show, :update]

  def index
    #render :json => current_user.store.open_orders.as_json(include: [:customer], methods: [:alterations_count])
    render :json => Tailor.all
  end
end
