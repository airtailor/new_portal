class Api::V1::ApiController < ApplicationController

  rescue_from ActionController::ParameterMissing, with: :render_params_missing_response
  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response

  def render_unprocessable_entity_response(exception)
    render json: { errors: exception.record.errors }, status: :unprocessable_entity
  end

  def render_not_found_response(exception)
    render json: { errors: [exception.message] }, status: :not_found
  end

  def render_params_missing_response(exception)
    message = exception.try(:message) || exception
    render json: { errors: [message] }, status: :unprocessable_entity
  end

  def full_messages_error(resource)
    render :json => { errors: resource.errors.full_messages }, status: :unprocessable_entity
    SendSonar.message_customer(text: resource.errors.full_messages, to: "6167804457")
  end

  private

  def api_authenticate
    api_key = request.headers['X-Api-Key']
    @user = User.where(api_key: api_key).first if api_key

    unless @user
      render json: { errors: ['Access Denied'] }, status: :unauthorized
      return false
    end
  end
end
