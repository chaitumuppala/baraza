require 'capybara/cucumber'

Capybara.default_driver = :selenium


Given(/^I am on the create new artciles page by clickin on "(.*?)"$/) do |createArticleButton|
  click_link('+ CREATE'); createArticleButton
end

When(/^I select the author "([^"]*)"$/) do |author_name|
  find(:css, "#s2id_owner-select > a > span.select2-arrow > b").click
  fill_in('s2id_autogen3_search', :with => author_name)
  find(:css, ".select2-match").click
end

And(/^I select the category "([^"]*)"$/) do |category|
    find(:css, "#s2id_category-select > a > span.select2-arrow > b").click
    fill_in('s2id_autogen2_search', :with => category)
    find(:css, ".select2-results > li").click
end

And(/^Enter the title "(.*?)"$/) do |articleTitle|
  fill_in('article_title',:with => articleTitle);
end

And(/^Enter the Summary "(.*?)" with the Content$/) do |summary|
  fill_in('summary',:with => summary + "\t" + "Hello World")

end

Then(/^click on "(.*?)"$/) do |publishButton|
  click_on('publish'); publishButton
  page.driver.browser.switch_to.alert.accept

end

And(/^the article should be created succesfully with a message "([^"]*)"$/) do |expectedText|
  page.has_content?(expectedText);
  sleep 5
end

