#require 'rubygems'
#require 'cucumber'
#require 'capybara/rails'
#require 'capybara'

require 'capybara/cucumber'
 
Capybara.default_driver = :selenium

#require 'testingbot/cucumber'






Given (/^I am on the signin page$/) do 
	visit("http://localhost:3000/users/sign_in")
end

When(/^I login with "(.*?)" and "(.*?)"$/) do |expectedText1, expectedText2|
	fill_in 'user_email', :with => expectedText1;
	fill_in 'user_password', :with => expectedText2;
end

And(/^I click on the "(.*?)" button$/) do |loginButton|
  click_button('Log in'); loginButton
end

Then(/^I should see "(.*?)"$/) do |expectedText3|
	page.has_content?(expectedText3)
end

Then(/^Close the browser$/) do
  page.driver.browser.close
end
  

 