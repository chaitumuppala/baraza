source 'https://rubygems.org'

# TODO: Vijay: Why not upgrade to the latest version of all the gems?
# TODO: Vijay: Its always a good idea to explicitly specify the versions of all gems so that all contributors are on the same versions
# TODO: Vijay: Why not specify the ruby version in the Gemfile - so as to act as a safety mechanism?

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
gem 'devise'
gem 'devise-i18n'
gem 'haml'
gem 'omniauth'
gem 'omniauth-google-oauth2'
gem 'omniauth-facebook'
gem 'foundation-rails', '5.4.5'
gem 'mysql2'
gem 'country_select', github: 'stefanpenner/country_select'
gem 'star_it'
gem 'ckeditor'
gem 'declarative_authorization'
gem 'loadjs'
gem 'elasticsearch-model'
gem 'elasticsearch-rails'
gem 'select2-rails'
gem 'social-share-button'
gem 'delayed_job_active_record'
gem 'daemons'
gem "paperclip", "~> 4.2"
gem 'aws-sdk', '~> 1.6'
gem 'meta-tags'
gem 'dotenv-rails'

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