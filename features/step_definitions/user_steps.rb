When(/^I click the "([^\"]*)" link$/) do |link_text|
  click_link(link_text)
end

Then(/^I should see "([^\"]*)"$/) do |text|
  page.has_content?(text)
end

Then(/^I should not see "([^\"]*)"$/) do |text|
  page.should_not have_content(text)
end

