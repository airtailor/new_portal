class Api::V1::ApiController < ApplicationController

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
