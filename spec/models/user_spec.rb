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
      invalid_user = FactoryGirl.build(:user, email: valid_user.email)
      expect(invalid_user).to_not be_valid
    end
  end

  describe "admin?" do
    before :each do
      @user = valid_user
    end

    context "when user has the role 'admin'" do
      it "returns true" do
        @user.add_role :admin
        expect(@user.admin?).to eq(true)
      end
    end

    context "when user does not have the role 'admin'" do
      it "returns false" do
        @user.add_role :tailor
        expect(@user.admin?).to eq(false)
      end
    end
  end

  describe "tailor?" do
    before :each do
      @user = valid_user
    end

    context "when user has the role 'tailor'" do
      it "returns true" do
        @user.add_role :tailor
        expect(@user.tailor?).to eq(true)
      end
    end

    context "when user does not have the role 'tailor'" do
      it "returns false" do
        @user.add_role :admin
        expect(@user.tailor?).to eq(false)
      end
    end
  end

  describe "delete_role" do
    before :each do
      @user = valid_user
      @user.add_role :admin
      @user.add_role :tailor
      @user.delete_role :tailor
    end

    it "deletes removes a specific role from the user" do
        expect(@user.has_role? :admin).to be(true)
        expect(@user.has_role? :tailor).to be(false)
    end

    it "does not delete the role from the database" do
        expect(Role.count).to eq(2)
    end
  end

  describe "update_roles" do
    before :each do
      @user = valid_user
      @user.add_role :tailor
      params = { tailor: "0", admin: "1" }
      @user.update_roles(params)
    end

    it "adds new roles correctly" do
      expect(@user.has_role? :admin).to be(true)
    end

    it "removes roles correctly" do
      expect(@user.has_role? :tailor).to be(false)
    end
  end
end
