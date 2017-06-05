class Admin::UsersController < ApplicationController 
  before_action :authorize_admin
  before_action :set_user, only: [:show, :edit, :update]
  load_and_authorize_resource :user

  def index 
    @users = User.all
  end

  def show 
  end

  def new 
    @user = User.new 
  end

  def create 
    @user = User.create(user_params)
    if @user.save 
      redirect_to [:admin, @user], notice: "User created successfully"
    else 
      render action: :new, alert: "Oops something went wrong"
    end 
  end

  def edit
  end

  def update 
    if @user.update_attributes(user_params)
      redirect_to [:admin, @user], notice: "User successfully updated"
    else 
      render action: :edit, alert: "Oops something went wrong"
    end
  end


  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :password)
  end
end
