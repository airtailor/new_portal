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
    @shipment.set_source_and_destination(params[:shipment_path])
    # lock this in to keep things stabilized, for now.
    @shipment.shipment_type ||= MAIL

    if @shipment.save
      @shipment.deliver
      render :json => @shipment.as_json
    else
      render :json => { :errors => @shipment.errors.full_messages }
    end
  end

  private

  def shipment_params
    params.require(:shipment, :shipment_path).permit(:order_id, :shipment_type)
  end
end


 # {"headers"=>{"client"=>"8Nw2urFSL2R6PKfFR9cHrA",
 #  "access-token"=>"1JbHz0JNmzWIYusFA_5GBQ", "uid"=>"test@tailoringnyc.com"},
 #  "message"=>{"id"=>6, "body"=>"Hi, Welcome to Air Tailor! Just message us here if you have any questions", "store_id"=>1, "conversation_id"=>6, "created_at"=>"2017-10-31T17:00:43.834Z", "updated_at"=>"2017-10-31T17:00:43.834Z", "sender_read"=>true, "recipient_read"=>true, "order_id"=>nil, "store"=>{"id"=>1, "company_id"=>1, "primary_contact_id"=>nil, "phone"=>"630 235 2554", "street1"=>"624 W 139th St", "street2"=>"Apt 1A", "city"=>"New York", "state"=>"New York", "zip"=>"10031", "country"=>"US", "created_at"=>"2017-10-31T16:59:37.786Z", "updated_at"=>"2017-10-31T16:59:37.786Z", "name"=>"Air Tailor", "address_id"=>nil}}, "store_id"=>"1", "conversation_id"=>"6", "id"=>"6"}
