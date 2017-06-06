require 'rails_helper'

RSpec.describe HomeController, type: :controller do 
  describe "GET #index" do 
    context "when user is logged in" do 
      before :each do 
        sign_in valid_user
      end
            
      it "renders the :index view" do 
        get :index
        expect(response).to render_template(:index)
      end

      it "does not render a different view" do 
        subject { get :index }
        expect(subject).to_not render_template("admin/users/index")
      end
    end

    context "when user is not logged in" do 
      it "redirects to the log in page" do 
        get :index
        expect(response).to redirect_to(new_user_session_path)
      end

      it "does not render the index page " do 
        subject { get :index }
        expect(subject).to_not render_template(:index)
      end
    end
  end
end
