module SpecTestHelper   
  def valid_user 
    FactoryGirl.create(:user)
  end

  def current_user
    User.find(request.session[:user])
  end

  def sign_in_admin user
    user.add_role(:admin)
    sign_in(user)
    user
  end

  def invalid_user_email

  end
end
