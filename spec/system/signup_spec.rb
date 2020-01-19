# frozen_string_literal: true

require 'rails_helper'

# FIXME: very basic registration test for now
RSpec.describe 'User Registration', type: :system, js: true do
  it 'allows user to sign up using form' do
    visit '/signup'

    # FIXME: add password entropy checking
    password = 'a' * 14

    fill_in 'firstName', with: 'test'
    fill_in 'lastName', with: 'test'
    fill_in 'email', with: 'test@gmail.com'
    fill_in 'password', with: password
    fill_in 'confirm_password', with: password
    click_button 'Register'

    expect(page).to have_current_path('/home')
  end
end
