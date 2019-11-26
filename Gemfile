# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.5'

gem 'bcrypt'
gem 'bootsnap'
gem 'jbuilder'
gem 'jwt_sessions'
gem 'pg'
gem 'puma'
gem 'rack-cors'
gem 'rails'
gem 'redis'
gem 'serviceworker-rails', github: 'rossta/serviceworker-rails'
gem 'webpacker'

group :development, :test do
  gem 'pry'
end

group :development do
  gem 'listen'
  gem 'rubocop'
  gem 'spring'
  gem 'spring-watcher-listen'
  gem 'web-console'
end

group :test do
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'webdrivers'
end
