class Api::PostmatesController < ApplicationController
  include DeliveryHelper

  def receive
    data = JSON.parse(request.body.read)
    DeliveryHelper.update_messenger_status(data)
    render json: {}, status: 200
  end
end
