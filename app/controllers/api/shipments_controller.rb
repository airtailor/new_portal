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
    @shipment.set_default_fields
    @shipment.set_source_and_destination(params[:action])
    # lock this in to keep things stabilized, for now.
    @shipment.shipment_type ||= MAIL

    @shipment.deliver

    if @shipment.save
      # figure this out below
      #@shipment.text_all_shipment_customers
      render :json => @shipment.as_json
    else
      render :json => { :errors => @shipment.errors.full_messages }
    end
  end

  private

  def shipment_params
    params.require(:shipment, :action).permit(:order_id, :shipment_type)
  end
end
