require 'rails_helper'

RSpec.describe Role, type: :model do
  before(:each) do
    @user = FactoryGirl.create(:user)
  end

  it "should not approve incorrect roles" do
    @user.add_role :tailor
    expect(@user.has_role? :admin).to be(false)
  end

  it "should approve correct roles" do
    @user.add_role :admin
    expect(@user.has_role? :admin).to be(true)
  end
end
