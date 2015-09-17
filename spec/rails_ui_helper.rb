# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'
# require 'simplecov'
require 'rails_helper'
require 'capybara/rails'
require 'capybara/rspec'

Dir[Rails.root.join('spec/features/pages/*.rb')].each { |f| require f }

RSpec.configure do |config|
  config.before(:each) do
    @login_page = LoginPage.new
    @article_list_page = ArticleListPage.new
    @article_page = ArticlePage.new
  end
end
