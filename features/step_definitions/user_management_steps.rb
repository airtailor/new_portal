#When(/^I create a new "([^"]*)" user$/) do |user_type|
#  user= FactoryGirl.attributes_for(:user)
#
#  page.check user_type 
#  fill_in "user_email", :with => user[:email] 
#  fill_in "user_password", :with => user[:password]
#  fill_in "user_password_confirmation", :with => user[:password]
#end

Given(/^user has role "([^"]*)"$/) do |role|
  @new_resource.add_role role
end

When(/^I change the user's "([^"]*)"$/) do |attribute|
  if attribute == "role"
    current_role = @new_resource.roles.first.name
    new_role = case current_role
      when "tailor" then "admin"
      when "admin" then "tailor"
    end
    page.uncheck current_role
    page.check new_role

  elsif attribute == "email"
    fill_in "user_email", :with => Faker::Internet.email
  end
end

