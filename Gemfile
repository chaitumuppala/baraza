source 'https://rubygems.org'
ruby "2.2.3"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.4'

gem 'pg'
gem 'foreman'
gem 'puma', '~> 2.13'

gem 'acts-as-taggable-on', '~> 3.4'

gem 'foundation-rails', '~> 5.4.5'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '~> 2.7.2'
# Use CoffeeScript for .coffee assets and views
# gem 'coffee-rails', '~> 4.1.0'
gem 'therubyracer', '~> 0.12.1', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails', '~> 4.0.4'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks', '~> 2.5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.2'
gem 'haml-rails', '~> 0.9.0'
# bundle exec rake doc:rails generates the API under doc/api.
# gem 'sdoc', '~> 0.4.0', group: :doc
gem 'devise', '~> 3.4.1'
gem 'devise-i18n', '~> 0.12.0'
gem 'omniauth-google-oauth2', '~> 0.2.6'
gem 'omniauth-facebook', '~> 2.0.1'
gem 'country_select', github: 'stefanpenner/country_select'
gem 'lodash-rails', '~> 3.10.1'
gem 'jquery-ui-rails', '~> 5.0.5'
gem 'star_it', '~> 0.0.1.3'
gem 'ckeditor', '~> 4.1.2'
gem 'declarative_authorization', '~> 0.5.7'
gem 'loadjs', '~> 0.0.6'
gem 'select2-rails', '~> 3.5.9'
gem 'social-share-button', '~> 0.1.8', git: 'https://github.com/cuterxy/social-share-button.git'
gem 'paperclip', '~> 4.2'
gem 'aws-sdk', '~> 1.6'
gem 'meta-tags', '~> 2.0.0'
gem 'dotenv-rails', '~> 2.0.2'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'
group :development do
  # gem 'stackprof', '~> 0.2.7'
  # gem 'derailed_benchmarks', '~> 1.0.1'
  # gem 'brakeman', '~> 3.0.5', require: false
  # gem 'flamegraph', '~> 0.1.0'
  # gem 'rack-mini-profiler', '~> 0.9.7'
  gem 'binding_of_caller', '~> 0.7.2'

  # gem 'rubocop', '~> 0.33', require: false
  # gem 'pronto', '~> 0.3.3'
  # gem 'pippi', '~> 0.0.3'
  # gem 'lol_dba', '~> 2.0.0'
  # gem 'jshint', '~> 1.4.0'

  # gem 'airbrussh', '~> 0.2.1', require: false
  # gem 'active_sanity', '~> 0.3.0'
end

group :development, :test do
  gem 'spring', '~> 1.3.6'
  gem 'quiet_assets', '~> 1.1.0'
  gem 'byebug', '~> 6.0.2'
  gem 'better_errors', '~> 2.1.1'
  gem 'pry-rails'
  gem 'pry-doc'
  gem 'awesome_print'
  gem 'did_you_mean', '~> 0.10.0'
  gem 'annotate', '~> 2.6.5'
  gem 'rspec-rails', '~> 3.3.3'
  gem 'factory_girl_rails', '~> 4.5'

  gem 'meta_request'
  # gem 'rspec-instafail', '~> 0.2.5'
  gem 'bullet', '~> 4.14.4'
  gem 'metric_fu', '~> 4.12.0'
  gem 'web-console', '~> 2.2.1'
  gem 'rails_instrument', '~> 0.0.4'
  gem 'faker', '~> 1.5.0'
end

group :test do
  gem 'shoulda-matchers'
  gem 'cucumber-rails', :require => false
  gem 'database_cleaner'
  gem 'capybara', '~> 2.5.0'
  # gem 'simplecov', '~> 0.10.0', require: false
end

group :production do
  gem 'rack-cache'
end
