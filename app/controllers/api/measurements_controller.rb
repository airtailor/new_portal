class Api::MeasurementsController < ApplicationController
  #before_action :authenticate_user!
  before_action :authenticate_user!, except: [:new, :create, :edit, :update]
  before_action :set_measurement, only: [:show]

  def show
    render :json => @measurement.to_json
  end

  def create
    measurement = Measurement.create(measurement_params)
    if measurement.save
      render :json => measurement
    else
      render :json => { :errors => measurement.errors.full_messages }
    end
  end

  private

  def set_measurement
    @measurement = Customer.find(params[:customer_id]).measurements.last
  end

  def measurement_params
    params.require(:measurement).permit(
      :sleeve_length,
      :shoulder_to_waist,
      :chest_bust,
      :upper_torso,
      :waist,
      :pant_length,
      :hips,
      :thigh,
      :knee,
      :calf,
      :ankle,
      :back_width,
      :bicep,
      :forearm,
      :inseam,
      :elbow,
      :customer)
  end
end
