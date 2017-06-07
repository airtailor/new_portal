When(/^I create a new "([^"]*)" user$/) do |user_type|
  user = FactoryGirl.attributes_for(:user)

  page.check user_type
  fill_in "user_email", :with => user[:email]
  fill_in "user_password", :with => user[:password]
  fill_in "user_password_confirmation", :with => user[:password]
end

Then(/^the new user should have the correct "([^"]*)"$/) do |attribute|
  if attribute == "role"
    User.last.has_role @current_user[attribute].first.name
  else
    User.last[attribute] == @current_user[attribute]
  end
end

Then(/^I should see the list of the user's roles$/) do 
  User.last.roles.each do |role|
    page.should have_content(role.name.capitalize)
  end
end
