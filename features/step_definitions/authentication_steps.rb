Given(/^I am the user with email "([^\"]*)"$/) do |email|
  @current_user = User.find_by(email: email)
end

Given(/^I log out$/)do
    visit(destroy_user_session_path)
end

Given(/^I log in as a "([^\"]*)" user$/) do |user_type|
  if user_type == "admin"
    email = "test@airtailor.com"
    password = "airtailor"
    role = :admin
  elsif user_type == "tailor"
    email = "test@joestailor.com"
    password = "joestailor"
    role = :tailor
  else
    byebug
  end

  store = FactoryGirl.create(:retailer)

  User.create(email: email, password: password, password_confirmation: password, store: store)
  User.last.add_role role

  visit "/users/sign_in"
  fill_in "user_email", :with => email
  fill_in "user_password", :with => password
  click_button "Log in"
end

  
