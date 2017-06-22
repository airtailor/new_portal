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
        @params = {}
        @params[:user] = FactoryGirl.attributes_for(:user)
        @params[:admin] = "1"
        @params[:tailor] = "0"
        @params[:user][:store_id] = FactoryGirl.create(:retailer).id
      end

      it "creates a new user" do 
        count = User.count
        post :create, @params 
        expect(User.count).to eq(count + 1)
      end

      it "updates user roles correctly" do 
        post :create, @params
        expect(User.last.has_role? :admin).to be(true)
        expect(User.last.has_role? :tailor).to be(false)
      end

      it "redirects to new user" do 
        post :create, @params
        expect(response).to redirect_to admin_user_path User.last
      end
    end

    context "with invalid attributes" do 
      before :each do 
        @params = {}
        @params[:user] = FactoryGirl.attributes_for(:user, password: nil)
        @params[:admin] = "1"
        @params[:tailor] = "0"
      end

      it "does not create a new user" do 
        count = User.count
        post :create, @params 
        expect(User.count).to eq(count)
      end

      it "re-renders the new method" do 
        post :create, @params
        expect(response).to render_template(:new) 
      end
    end
  end

  describe "Patch #update" do 
    context "with valid attributes"
      before :each do 
        @user = valid_user
        @new_user_info = FactoryGirl.attributes_for(:user)
        patch :update, id: @user, user: @new_user_info, admin: "1", tailor: "0" 
      end

      it "updates a user correctly" do 
        expect(User.last.email).to eq(@new_user_info[:email])
        expect(User.last.has_role? :tailor).to be(false)
        expect(User.last.has_role? :admin).to be(true)
      end

      it "redirects to user" do 
        expect(response).to redirect_to admin_user_path @user 
      end

    context "with invalid attributes" do 
      before :each do 
        @user = valid_user
        @new_user_info = FactoryGirl.attributes_for(:user, email: nil)
        patch :update, id: @user, user: @new_user_info, admin: "1", tailor: "0" 
      end

      it "does not save changes" do 
        expect(User.last.has_role? :admin).to eq(false)
        expect(User.last.email).to_not eq(@new_email)
      end

      it "re-renders the edit method" do 
        expect(response).to render_template(:edit) 
      end
    end
  end
end

