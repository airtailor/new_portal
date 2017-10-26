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
    if @shipment.save && @shipment.deliver
      render :json => @shipment.return
                        .as_json(include: [
                            :incoming_shipment, :outgoing_shipment, :customer,
                            :items => {include: [:item_type, :alterations]}
                          ])
    else
      render :json => { :errors => @shipment.errors.full_messages }
    end
  end

  def cancel
    # cancel a postmates delivery
    # using the PostmatesHelper
  end

  private

  def shipment_params
    params.require(:shipment).permit(:order_id, :type)
  end
end
