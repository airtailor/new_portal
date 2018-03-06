class Api::V1::ApiController < ApplicationController

  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response

  def render_unprocessable_entity_response(exception)
    render json: exception.record.errors, status: :unprocessable_entity
  end

  def render_not_found_response(exception)
    render json: { error: exception.message }, status: :not_found
  end

  private

  def api_authenticate
    api_key = request.headers['X-Api-Key']
    @user = User.where(api_key: api_key).first if api_key

    unless @user
      render json: { error: 'Access Denied' }, status: :unauthorized
      return false
    end
  end
end
