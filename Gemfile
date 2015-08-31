source 'https://rubygems.org'

ruby '2.2.2'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.1'
# Use sqlite3 as the database for Active Record
# gem 'sqlite3'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
# gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby
gem 'execjs'
gem 'therubyracer'

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
# gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
gem 'haml-rails'
# bundle exec rake doc:rails generates the API under doc/api.
# gem 'sdoc', '~> 0.4.0', group: :doc
gem 'devise', '~> 3.4.1'
gem 'devise-i18n', '~> 0.12.0'
gem 'haml', '~> 4.0.6'
gem 'omniauth', '~> 1.2.2'
gem 'omniauth-google-oauth2', '~> 0.2.6'
gem 'omniauth-facebook', '~> 2.0.1'
gem 'foundation-rails', '5.4.5'
gem 'mysql2', '~> 0.3.18'
gem 'country_select', github: 'stefanpenner/country_select'
gem 'star_it'
gem 'ckeditor', '~> 4.1.2'
gem 'declarative_authorization', '~> 0.5.7'
gem 'loadjs', '~> 0.0.6'
gem 'elasticsearch-model', '~> 0.1.7'
gem 'elasticsearch-rails', '~> 0.1.7'
gem 'select2-rails', '~> 3.5.9'
gem 'social-share-button', '~> 0.1.8'
gem 'delayed_job_active_record', '~> 4.0.3'
gem 'daemons'
gem "paperclip", "~> 4.2"
gem 'aws-sdk', '~> 1.6'
gem 'meta-tags', '~> 2.0.0'
gem 'dotenv-rails', '~> 2.0.2'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'
group :development do
# Use Capistrano for deployment
  gem 'capistrano', '~> 3.4.0'
  gem 'capistrano-rails', '~> 1.1.0'
  gem 'capistrano-rvm'
  gem 'capistrano-bundler', '~> 1.1.2'
  gem 'capistrano-passenger'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'rspec-rails'
  gem 'bullet'
end

group :test do
  gem 'factory_girl_rails'
  gem 'shoulda-matchers'
  gem 'simplecov', :require => false
end