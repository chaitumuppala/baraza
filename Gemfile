source 'https://rubygems.org'
ruby "2.2.3"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.4'
# Use sqlite3 as the database for Active Record
# gem 'sqlite3'
gem 'mysql2', '~> 0.3.20'
gem 'pg'
gem 'puma', '~> 2.13'
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
gem 'elasticsearch-model', '~> 0.1.7'
gem 'elasticsearch-rails', '~> 0.1.7'
gem 'select2-rails', '~> 3.5.9'
gem 'social-share-button', '~> 0.1.8', git: 'https://github.com/cuterxy/social-share-button.git'
gem 'delayed_job_active_record', '~> 4.0.3'
gem 'daemons', '~> 1.2.3'
gem 'paperclip', '~> 4.2'
gem 'aws-sdk', '~> 1.6'
gem 'meta-tags', '~> 2.0.0'
gem 'dotenv-rails', '~> 2.0.2'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'
group :development do
  gem 'stackprof', '~> 0.2.7'
  gem 'derailed_benchmarks', '~> 1.0.1'
  gem 'brakeman', '~> 3.0.5', require: false
  gem 'flamegraph', '~> 0.1.0'
  gem 'rack-mini-profiler', '~> 0.9.7'
  gem 'binding_of_caller', '~> 0.7.2'

  gem 'rubocop', '~> 0.33', require: false
  # gem 'pronto', '~> 0.3.3'
  # gem 'pippi', '~> 0.0.3'
  gem 'lol_dba', '~> 2.0.0'
  gem 'jshint', '~> 1.4.0'

  gem 'guard-bundler', '~> 2.1.0', require: false
  gem 'guard-rails', '~> 0.7.2'
  gem 'guard-rspec', '~> 4.6.4'
  # gem 'rails_layout', '~> 1.0.26'
  # gem 'rb-fchange', '~> 0.0.6', require: false
  # gem 'rb-fsevent', '~> 0.9.5', require: false
  # gem 'rb-inotify', '~> 0.9.5', require: false
  # gem 'spring-commands-rspec'

  # Use Capistrano for deployment
  gem 'capistrano-rails', '~> 1.1.2'
  gem 'capistrano-rvm', '~> 0.1.2'
  gem 'capistrano-bundler', '~> 1.1.2'
  gem 'capistrano-faster-assets', '~> 1.0'
  gem 'capistrano-passenger', '~> 0.1.1'
  gem 'airbrussh', '~> 0.2.1', require: false
  gem 'active_sanity', '~> 0.3.0'
end

group :development, :test do
  gem 'foreman'
  gem 'spring', '~> 1.3.6'
  gem 'quiet_assets', '~> 1.1.0'
  gem 'byebug', '~> 6.0.2'
  gem 'better_errors', '~> 2.1.1'
  gem 'pry-rails', '~> 0.3.2'
  gem 'did_you_mean', '~> 0.10.0'
  gem 'annotate', '~> 2.6.5'
  gem 'rspec-rails', '~> 3.3.3'
  # gem 'rspec-instafail', '~> 0.2.5'
  gem 'bullet', '~> 4.14.4'
  gem 'metric_fu', '~> 4.12.0'
  gem 'web-console', '~> 2.2.1'
  gem 'rails_instrument', '~> 0.0.4'
  gem 'faker', '~> 1.5.0'

  # Use debugger
  # gem 'debugger'
end

group :test do
  # gem 'capybara'
  gem 'database_cleaner', '~> 1.4.0'
  gem 'factory_girl_rails', '~> 4.5'
  gem 'shoulda', '~> 3.5.0'
  gem 'simplecov', '~> 0.10.0', require: false
  # gem 'selenium-webdriver'
end

group :production do
  # Turn on caching using rack-cache
  gem 'rack-cache', '~> 1.2', require: 'rack/cache'
end
