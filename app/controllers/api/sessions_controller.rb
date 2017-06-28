class Api::SessionsController < ApplicationController
   protect_from_forgery with: :null_session, if: -> { request.format.json? }

  def create
    byebug
  end

  def destroy
  end
end
