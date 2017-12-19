class Api::PostmatesController < ApplicationController
  def receive
    byebug
    render json: {}, status: 200
  end
end
