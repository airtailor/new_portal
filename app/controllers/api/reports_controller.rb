class Api::ReportsController < ApplicationController
  before_action :authenticate_user!

  def current_report
    sql_includes = [ :tailor, :retailer, :customer ]
    orders = Order.current_report.includes(*sql_includes).as_json(
                      include: sql_includes, methods: [ :alterations_count ]
                    )

    report = {orders: orders} 

    render :json => report
  end

end
