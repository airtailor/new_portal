class Api::StoresController < ApplicationController
  before_action :authenticate_user!
  def show
    render json: current_user.store
  end
end