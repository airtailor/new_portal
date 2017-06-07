When(/^I click the "([^\"]*)" link$/) do |link_text|
  click_link(link_text)
end

When(/^I click the "([^\"]*)" button$/) do |button_text|
  click_link_or_button(button_text)
end

Then(/^I should see "([^\"]*)"$/) do |text|
  page.has_content?(text)
end

Then(/^I should not see "([^\"]*)"$/) do |text|
  page.should_not have_content(text)
end

Then(/^I should see the new user's "([^\"]*)"$/) do |attribute|
  page.has_content?(attribute)
end

