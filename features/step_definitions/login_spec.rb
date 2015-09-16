require 'rubygems'
require 'cucumber'
require 'watir-webdriver'


Given(/^I am on the homepage$/) do
	@b = Watir::Browser.new :ff
	@b.goto 'localhost:3000'
end


When(/^Click Login/) do
	l = @b.link :text => 'LOGIN'
	l.click
end

When(/^Provide "(.*?)" and "(.*?)" to login$/) do |email, password|
	@b.text_field(:id => 'user_email').set(email)
	@b.text_field(:id => 'user_password').set(password)
	@b.button(:value => 'Log in').click
end

Then(/^Validate error message "(.*?)"$/) do |message|
	@b.text.should include(message)
  @b.quit
end

And(/^Validate successful user login$/) do
	@b.text.should_not include("LOGIN")
end

Then(/^Logout the user$/) do
	pending
end