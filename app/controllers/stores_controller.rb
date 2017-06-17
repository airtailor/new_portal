class StoresController < ApplicationController
  def show
    @store = current_user.store
  end
end
