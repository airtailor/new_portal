require 'rails_helper'

RSpec.describe User, type: :model do
  it "is invalid without an email" do
    invalid_user = FactoryGirl.build(:user, email: nil)
    expect(invalid_user).to_not be_valid
  end

  it "is invalid without a password" do
    invalid_user = FactoryGirl.build(:user, password: nil)
    expect(invalid_user).to_not be_valid
  end

  context "when email is already taken" do
    it "is invalid" do
      valid_user = FactoryGirl.create(:user)
      invalid_user = FactoryGirl.build(:user, email: valid_user.email)

      expect(invalid_user).to_not be_valid
    end
  end

  describe "admin?" do 
    context "when user has the role 'admin'" do 
      it "returns true" do 
        admin_user = FactoryGirl.create(:user)
        admin_user.add_role :admin

        expect(admin_user.has_role? :admin).to eq(true)
      end
    end

    context "when user does not have the role 'admin'" do 
      it "returns false" do 
        tailor_user = FactoryGirl.create(:user)
        tailor_user.add_role :tailor

        expect(tailor_user.has_role? :admin).to eq(false)
      end
    end
  end

  describe "delete_role" do 
    it "deletes removes a specific role from the user" do 
        admin_user = FactoryGirl.create(:user, email: Faker::Internet.email)
        admin_user.add_role :admin
        admin_user.add_role :tailor
        admin_user.delete_role :tailor

        expect(admin_user.has_role? :admin).to be(true)
        expect(admin_user.has_role? :tailor).to be(false)
    end

    it "does not delete the role from the database" do 
        admin_user = FactoryGirl.create(:user, email: Faker::Internet.email)
        admin_user.add_role :admin
        admin_user.add_role :tailor
        admin_user.delete_role :tailor

        expect(Role.count).to eq(2)
    end
  end
end
