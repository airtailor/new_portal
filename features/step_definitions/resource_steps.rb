Given(/^a "([^"]*)" exists$/) do |resource|
  @new_resource = FactoryGirl.create(resource)
end

Then(/^the new "([^"]*)" should have the correct "([^"]*)"$/) do |resource, attribute|
  resource_class = case resource 
    when "user" then User
  end

  resource_class.last[attribute] == @new_resource[attribute]
end

Then(/^I should see the "([^\"]*)"'s "([^\"]*)"$/) do |resource, attribute|
  resource_class = case resource 
    when "user" then User.last
  end

  resource = @new_resource || resource_class

  if attribute == "role"
    content = resource.roles.first.name
  else 
    content = resource[attribute] 
  end

  page.has_content?(content)
end
