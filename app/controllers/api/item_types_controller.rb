class Api::ItemTypesController < ApplicationController
  before_action :authenticate_user!

  def index
    render :json => ItemType.all
  end
end
