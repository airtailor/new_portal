Then(/^I am on the "([^"]*)" page$/) do |route| 
  visit route
end

When(/^I go to the "([^"]*)" page$/) do |route| 
  visit route
end

Then(/^I should be redirected to the "([^"]*)" page$/) do |route|
  page.current_path.should == route
end

Then(/^I should be brought to the "([^"]*)" page$/) do |route|
  page.current_path.should == route
end


Then(/^I should be redirected to the user's store page$/) do
  page.current_path.should == "/stores/#{User.last.store.id}" 
end




