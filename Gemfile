# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.0'
# Use mysql as the database for Active Record
gem 'mysql2'
# Use Unicorn as the app server
gem 'unicorn'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'mini_racer', platforms: :ruby

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'web-console', '>= 3.3.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring

  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :development, :test do
  # unit test
  gem 'rspec'
  # create test data
  gem 'factory_bot_rails'
  # test coverage
  gem 'simplecov'

  gem 'brakeman'
  gem 'rails_best_practices'
  gem 'rspec-rails'
  gem 'rubocop'
  gem 'rubocop-rspec'
end

group :test do
  gem 'codeclimate-test-reporter'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

# out put ruby doc
gem 'yard'

# fontawesome
gem 'font-awesome-sass', '~> 5.2.0'

gem 'unicorn-worker-killer'

#devise
#delete gem 'devise'
#delete gem 'devise-i18n'

gem 'activerecord-session_store'

# mock
gem 'webmock'

# aws-sdk, Lambda
#delete gem 'aws-sdk', '~> 3'

gem 'i18n'
gem 'i18n-js'

# Use Chart.js
gem 'chart-js-rails'

# Use jquery-rails for jquery using ajax
gem 'jquery-rails'

# elasticsearch
gem 'elasticsearch-model'
gem 'elasticsearch-rails'


#delete gem 'carrierwave'
#delete gem 'mini_magick'
# gem 'fog'

gem 'curb'
gem 'redis'
gem 'websocket-rails'
gem "faye-websocket"
gem "sinatra"