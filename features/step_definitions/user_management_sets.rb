When(/^I create a new "([^"]*)" user$/) do |user_type|
  if user_type == "admin"
    email = "test@airtailor.com"
    password = "airtailor"
    non_role = :tailor
  elsif user_type == "tailor"
    email = "test@joestailor.com"
    password = "joestailor"
    non_role = :admin
  else 
    byebug
  end

  @current_user = {email: email, role: user_type}

  page.check user_type
  fill_in "user_email", :with => email 
  fill_in "user_password", :with => password
  fill_in "user_password_confirmation", :with => password
end

Then(/^the new user should have the correct "([^"]*)"$/) do |attribute|
  if attribute == "role"
    User.last.has_role @current_user[attribute].first.name
  else
    User.last[attribute] == @current_user[attribute]
  end
end
