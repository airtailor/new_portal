require "rails_helper"

describe "rake :daily_shopify_reconciliation", type: :task do
  require "rake"
  rake = Rake::Application.new
  Rake.application = rake
  rake.init
  rake.load_rakefile

  it "Grabs all the latest orders from the last 24 hour period" do
    rake['daily_shopify_reconciliation'].invoke
  end
end
