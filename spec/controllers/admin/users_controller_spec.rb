require 'rails_helper'

RSpec.describe Admin::UsersController, type: :controller do 
  before :each do 
    @user = sign_in_admin valid_user
  end

  describe "GET #index" do 
      before :each do 
        get :index
      end

      it "assigns @users" do 
        expect(assigns(:users)).to eq([@user])
      end

      it "renders the index view" do 
        expect(response).to render_template(:index)
      end
  end

  describe "GET #show" do 
    before :each do 
      get :show, id: @user.id
    end

    it "assigns @user" do 
      expect(assigns(:user)).to eq(@user)
    end

    it "renders the show view" do 
      expect(response).to render_template(:show)
    end
  end

  describe "GET #new" do 
    before :each do 
      get :new
      @user = User.new 
    end

    it "assigns @user" do 
      expect(assigns(:user)).to be_a_new(User)
    end

    it "renders the new view" do 
      expect(response).to render_template(:new)
    end
  end

  describe "Get #edit" do 
    before :each do 
      get :show, id: @user.id
    end

    it "assigns @user" do 
      expect(assigns(:user)).to eq(@user)
    end

    it "renders the edit view" do 
      expect(response).to render_template(:show)
    end
  end

  describe "Post #create" do 
    context "with valid attributes" do 
      before :each do 
        @count = User.count
        @user_attributes = FactoryGirl.attributes_for(:user)
        @user_attributes[:admin] = "1"
        @user_attributes[:tailor] = "1"
      end

      it "creates a new user" do 
        post :create, user: @user_attributes
        expect(User.count).to eq(@count + 1)
      end

      it "redirects to new user" do 
        post :create, user: @user_attributes 
        expect(response).to redirect_to admin_user_path User.last
      end
    end

    context "with invalid attributes"
      it "does not create a new user"
      it "re-renders the new method"
  end

  describe "Patch #update" do 
    context "with valid attributes"
      it "updates a user"
      it "responds with a 200 ok"
    context "with invalid attributes"
      it "does not save changes"
      it "re-renders the edit method"
  end
end
