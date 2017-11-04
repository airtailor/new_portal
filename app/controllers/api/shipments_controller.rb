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
    shipment_action = params[:shipment][:shipment_action]
    @shipment = Shipment.new(shipment_params)

    @shipment.set_default_fields
    source_model, destination_model = @shipment.parse_src_dest(
      shipment_action, @shipment.shipment_type
    )

    order_ids = [params[:shipment][:order_id]]  # the front-end should pass an arr
    orders_in_shipment = Order.where(id: order_ids)
    count_entities_in_order = {
      retailer: orders_in_shipment.select(:requester_id).distinct.count,
      tailor: orders_in_shipment.select(:provider_id).distinct.count,
      customer: orders_in_shipment.select(:customer_id).distinct.count
    }

    relevant_entities = [source_model, destination_model]
    valid_shipment = relevant_entities.all?{ |klass|
      count_entities_in_order[klass] == 1
    }

    if valid_shipment
      @shipment.source = orders_in_shipment.first.send(source_model)
      @shipment.destination = orders_in_shipment.first.send(destination_model)
    end

    binding.pry
    @shipment.deliver


    if @shipment.deliver && @shipment.save
      #@shipment.text_all_shipment_customers
      render :json => @shipment.as_json
    else
      render :json => { :errors => @shipment.errors.full_messages }
    end
  end

  private

  def shipment_params
    params.require(:shipment).permit(:shipment_type)
  end
end
