class Api::PaymentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_payable, :only => [:update_payment_method]
  before_action :set_token, :only => [:update_payment_method]
 
  def update_payment_method
    default_payment = @payable.add_default_payment(@token)
    if default_payment
      render :json => {}, status: 200
    else 
      render :json => {error: "SOMETHING SOMETHING DARK SIDE"}, status: 666
    end
  end


  private 

  def set_token
    @token = params[:payment][:token]
  end

  def set_payable
    payable_type = params[:payment][:payable_type].constantize
    payable_id = params[:payment][:payable_id]
    @payable = payable_type.find(payable_id)
  end
end
