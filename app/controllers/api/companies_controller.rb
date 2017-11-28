class Api::CompaniesController < ApplicationController
  before_action :authenticate_user!, except: [ :create ]

  def create
    @company = Company.new(company_params)
    if @company.save
      render :json => { status: 200 }
    else
      render :json => { errors: 'Company creation failed. Check your inputs.'}
    end
  end

  def index
    render :json => Company.all.as_json #current_user.store.open_orders.as_json(include: [:customer], methods: [:alterations_count])
  end

  private

  def company_params
    params.require(:company).permit(:name)
  end
end
