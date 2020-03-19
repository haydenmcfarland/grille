# frozen_string_literal: true

Rails.application.config.content_security_policy do |policy|
  if Rails.env.development?
    policy.script_src :self, :https, :unsafe_eval, :unsafe_inline
    policy.connect_src(
      :self,
      :https,
      'http://localhost:3000',
      'ws://localhost:3000'
    )
  else
    policy.script_src :self, :https
  end
end
