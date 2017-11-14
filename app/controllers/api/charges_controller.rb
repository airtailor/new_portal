class Api::ChargesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_payable, :only => [:create]
  before_action :set_amount, :only => [:create]

  def create
    stripe_charge = Charge.initiate_charge(
      @amount,
      @payable.stripe_id 
    )
    
    if stripe_charge[:error]
      puts stripe_charge[:error]
      render :json => {errors: ["There was an error processing your payment"]}
    elsif stripe_charge[:id] 
      binding.pry
      if charge.save
        render :json => charge
      else 
        binding.pry
        render :json => {errors: ["There was an error processing your payment"]}
      end
    end
  end

  private 

  def set_amount
    @amount = params[:charge][:amount]
  end

  def set_payable
    payable_type = params[:charge][:payable_type]
    payable_id = params[:charge][:payable_id]

    @payable = payable_type.constantize.find(payable_id)
  end

  def charge_params
    params.require(:charge)
      .permit(
        :payable_id,
        :payable_type,
        :amount,
        :chargable_id,
        :chargable_type
    )
  end
end
