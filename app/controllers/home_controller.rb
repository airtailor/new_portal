class HomeController < ApplicationController
  before_filter :logged_in

  def index
  end

  private 

  def logged_in
    if !current_user
      redirect_to "/users/sign_up"
    end
  end
end
