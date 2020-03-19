# frozen_string_literal: true

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.before(:each, type: :system, js: true) do
    allow_any_instance_of(ActionController::Base)
      .to receive(:protect_against_forgery?).and_return(true)
    driven_by :selenium_chrome_headless
  end
end
