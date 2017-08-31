class Admin::UsersController < ApplicationController
  before_action :authorize_admin
  before_action :set_user, only: [:show, :edit, :update]
  before_action :set_roles, only: [:new, :edit]
  before_action :check_for_empty_password, only: [:update]
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
      update_roles
      redirect_to [:admin, @user], notice: "User created successfully"
    else
      render action: :new, alert: "Oops something went wrong"
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      update_roles
      redirect_to [:admin, @user], notice: "User successfully updated"
    else
      render action: :edit, alert: "Oops something went wrong"
    end
  end

  private

  def update_roles
    @user.update_roles(params)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :password, :store_id)
  end
end
