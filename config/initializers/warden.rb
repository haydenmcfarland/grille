# frozen_string_literal: true

::Warden::JWTAuth.configure do |config|
  config.mappings = { user: Grille::User }
  config.revocation_strategies = { user: Grille::User }
  config.secret = ENV['GRILLE_JWT_SECRET_KEY'] ||
                  Rails.application.secrets.secret_key_base ||
                  (Rails.env != 'production' ? 'test' : nil)

  exp = ENV['GRILLE_JWT_EXPIRATION_TIME'].to_i
  config.expiration_time = exp.positive? ? expiration.days.to_i : 30.days.to_i
  config.aud_header = ENV['GRILLE_JWT_AUD_HEADER'] || 'grille'
end
