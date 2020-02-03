# frozen_string_literal: true

require 'rails_helper'

# FIXME: very basic registration test for now
RSpec.describe 'User Login', type: :system, js: true do
  it 'allows user to sign in using form if already registered' do
    # FIXME: add password entropy checking
    password = 'a' * 14

    user = ::Grille::User.create!(
      first_name: 'test',
      last_name: 'test',
      email: 'test@gmail.com',
      password: password
    )

    # we should get redirected to signin
    visit '/'

    fill_in 'email', with: user.email
    fill_in 'password', with: password
    click_button 'Login'

    expect(page).to have_current_path('/home')
  end
end
