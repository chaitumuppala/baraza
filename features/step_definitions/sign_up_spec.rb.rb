require 'rubygems'
require 'cucumber'
require 'watir-webdriver'

And(/^Open new user form with Signup$/) do
  @b.link(:text => 'SIGN UP').click
end

And(/^Enter First name "([^"]*)"$/) do |firstname|
  @b.link(:id => 'user_first_name').set(firstname)
end

And(/^Enter Last name "([^"]*)"$/) do |lastname|
  @b.link(:id => 'user_last_name').set(lastname)
end


And(/^Enter Email "([^"]*)"$/) do |email|
  @b.link(:id => 'user_email').set(email)
end


And(/^Enter Password "([^"]*)"$/) do |password|
  @b.link(:id => 'user_password').set(password)
end


And(/^Enter Confirm Password "([^"]*)"$/) do |confirm|
  @b.link(:id => 'user_password_confirmation').set(confirm)
end

And(/^Enter Date of Birth "([^"]*)"$/) do |year|
  @b.link(:id => 'user_year_of_birth').send_keys(year)
end

And(/^Enter Country "([^"]*)"$/) do |country|
  @b.link(:id => 'user_country').send_keys(country)
end

And(/^Select Gender "([^"]*)"$/) do |gender|
  if gender == "Male"
    @b.link(:id => 'user_gender_m').set
  end
  if gender == "Female"
    @b.link(:id => 'user_gender_f').set
  end
  if gender == "Other"
    @b.link(:id => 'user_gender_other').set
  end
end

And(/^Click Register a new user$/) do
  @b.button(:value => 'Register').click
end

Then(/^Validate success message is "([^"]*)"$/) do |message|
  @b.text.should include(message)

end