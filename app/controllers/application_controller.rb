class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  def authorize_admin
    redirect_to root_path, alert: "Access Denied" unless current_user.admin?
  end

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { head :forbidden }
      format.html { redirect_to main_app.root_url, :alert => exception.message }
    end
  end

  private 

  def update_user_roles
    if params[:admin] == "1"
      @user.grant(:admin)
    elsif params[:admin] == "0"
      @user.delete_role(:admin)
    end

    if params[:tailor] == "1"
      @user.grant(:tailor)
    elsif params[:tailor] == "0"
      @user.delete_role(:tailor)
    end
  end

  def set_roles
    @roles = [:admin, :tailor]
  end

  def check_for_empty_password
    params[:user].delete(:password) if params[:user][:password].blank?
    params[:user].delete(:password_confirmation) if params[:user][:password].blank? and params[:user][:password_confirmation].blank?
  end
end
