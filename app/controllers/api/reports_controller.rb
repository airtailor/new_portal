class Api::ReportsController < ApplicationController
  before_action :authenticate_user!

  def current_report
    sql_includes = [ :tailor, :retailer, :customer ]
    start_date, end_date = Order.report_dates
    orders = TailorOrder.current_report.includes(*sql_includes).as_json(
                      include: sql_includes, methods: [ :alterations_count ]
                    )

    report = {orders: orders, start_date: start_date, end_date: end_date} 

    render :json => report
  end

end
