class Api::ReportsController < ApplicationController
  before_action :authenticate_user!

  def current_report
    binding.pry

  end
end
