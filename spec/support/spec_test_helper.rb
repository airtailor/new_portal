module SpecTestHelper   
  def login(user)
    request.session[:user] = user.id
  end

  def valid_user 
    FactoryGirl.create(:user)
  end

  def current_user
    User.find(request.session[:user])
  end
end
