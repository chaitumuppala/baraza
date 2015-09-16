require 'rubygems'
require 'cucumber'
require 'watir-webdriver'

And(/^Open new user form with Signup$/) do
  @b.link(:text => 'SIGN UP').click
end

And(/^Enter First name "([^"]*)"$/) do |firstname|
  @b.text_field(:id => 'user_first_name').set(firstname)
end

And(/^Enter Last name "([^"]*)"$/) do |lastname|
  @b.text_field(:id => 'user_last_name').set(lastname)
end


And(/^Enter Email "([^"]*)"$/) do |email|
  @b.text_field(:id => 'user_email').set(email)
end


And(/^Enter Password "([^"]*)"$/) do |password|
  @b.text_field(:id => 'user_password').set(password)
end


And(/^Enter Confirm Password "([^"]*)"$/) do |confirm|
  @b.text_field(:id => 'user_password_confirmation').set(confirm)
end

And(/^Enter Date of Birth "([^"]*)"$/) do |year|
  @b.select_list(:id => 'user_year_of_birth').select(year)
end

And(/^Enter Country "([^"]*)"$/) do |country|
  @b.select_list(:id => 'user_country').select(country)
end

And(/^Select Gender "([^"]*)"$/) do |gender|
  if gender == "Male"
    @b.radio(:id => 'user_gender_m').set
  end
  if gender == "Female"
    @b.radio(:id => 'user_gender_f').set
  end
  if gender == "Other"
    @b.radio(:id => 'user_gender_other').set
  end
end

And(/^Click Register a new user$/) do
  @b.button(:value => 'Register').click
end

Then(/^Validate success message is "([^"]*)"$/) do |message|
  @b.text.should include(message)

end