class Api::UsersController < ApplicationController
  # before_action :authenticate_user!
  before_action :set_user, only: [:update_password]

  def update_password
    if @user.update_password(password_params)
      render :json => @user.as_json
    else
      render :json => {errors: message.errors.full_message}
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
