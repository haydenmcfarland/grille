# frozen_string_literal: true

require 'selenium/webdriver'
require 'capybara'

headless = ENV['HEADLESS'] == 'true'
Capybara.javascript_driver = headless ? :selenium_chrome_headless : :selenium
