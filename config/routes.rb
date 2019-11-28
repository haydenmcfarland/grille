# frozen_string_literal: true

Rails.application.routes.draw do
  root 'landing#index'
  get 'landing/index'

  namespace :api do
    namespace :v1 do
      # routes go here
    end
  end

  post 'refresh', controller: :refresh, action: :create
  post 'signin', controller: :signin, action: :create
  post 'signup', controller: :signup, action: :create
  delete 'signin', controller: :signin, action: :destroy

  # utilized to use vue-router history mode
  match '/*path', to: redirect('/?redirect=%{path}'), via: :all
end
