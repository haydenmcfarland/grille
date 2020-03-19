# frozen_string_literal: true

require 'devise'
require 'devise/jwt'

Devise.setup do |config|
  config.router_name = :grille
  config.parent_controller = 'Grille::ApplicationController'
  config.secret_key = ENV['GRILLE_DEVISE_SECRET_KEY'] ||
                      Rails.application.secrets.secret_key_base

  require 'devise/orm/active_record'

  config.case_insensitive_keys = [:email]
  config.strip_whitespace_keys = [:email]
  config.skip_session_storage = %i[http_auth token_auth]
  config.stretches = Rails.env.test? ? 1 : 11
  config.reconfirmable = true
  config.expire_all_remember_me_on_sign_out = true
  config.password_length = 6..128
  config.email_regexp = /\A[^@\s]+@[^@\s]+\z/
  config.reset_password_within = 6.hours
  config.sign_out_via = :delete
end
