require 'rails_helper'

RSpec.describe Api::MessagesController, type: :controller do
  before :each do 
    @airtailor_co = FactoryGirl.create(:company, name: "Air Tailor")
    @airtailor_store = FactoryGirl.create(:retailer, name: "Air Tailor", company: @airtailor_co)

    @retailer_co = FactoryGirl.create(:company, name: "J.Crew")
    @retailer_store = FactoryGirl.create(:retailer, name: "J.Crew - 5th Ave", company: @retailer_co)

    @admin_user = FactoryGirl.create(:user, store: @airtailor_store)
    @admin_user.add_role "admin"

    @retailer_user = FactoryGirl.create(:user, store: @retailer_store)
    @retailer_user.add_role "retailer"

    @auth_headers = @admin_user.create_new_auth_token

    @conversation = Conversation.where(recipient: @retailer_store, sender: @airtailor_store)

    @message_one = FactoryGirl.create(
      :message,
      store: @retailer_store,
      conversation: @conversation
    )

    @message_two = FactoryGirl.create(
      :message,
      store: @airtailor_store,
      conversation: @conversation
    )
  end

  describe "POST #create" do 

  end

end
