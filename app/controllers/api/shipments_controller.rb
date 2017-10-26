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
