class HomeController < ApplicationController
  def index
    redirect_to "/stores/#{current_user.store.id}"
  end
end
