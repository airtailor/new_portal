class Api::ShipmentsController < ApplicationController
  before_action :authenticate_user!, except: [:create]

  def show
    @shipment = Shipment.where(id: params[:id]).first

    if @shipment
      render :json => @shipment.to_json
    else
      render :json => { :errors => "Shipment not found." }
    end
  end

  def create
    @shipment = Shipment.new(shipment_params)
    # this needs checking
    @shipment.source ||= "Shopify"
    air_tailor_co = Company.where(name: "Air Tailor").select(:id)

    @shipment.retailer ||= Retailer.find_by(company: air_tailor_co, name: "Air Tailor")
    @shipment.fulfilled ||= false

    stores_with_tailors = [
      "Steven Alan - Tribeca",
      "Frame Denim - SoHo",
      "Rag & Bone - SoHo"
    ]

    @shipment.weight = self.orders.sum(:weight)

    if @shipment.retailer.name.in? stores_with_tailors
      @shipment.tailor = Tailor.where(name: "Tailoring NYC").first
    end


    case @shipment.shipment_type
    when MAIL
      @shipment.create_label
    when MESSENGER
      @shipment.request_messenger
    else
      raise StandardError
    end

    if @shipment.save
      # return a message here saying "you made it!"
      render :json => @shipment.as_json
    else
      render :json => { :errors => @shipment.errors.full_messages }
    end
  end

  private

  def shipment_params
    params.require(:shipment, :shipment_type).permit(:order_id, :type)
  end
end
