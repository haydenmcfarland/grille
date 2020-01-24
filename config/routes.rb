# frozen_string_literal: true

Rails.application.routes.draw do
  if Rails.env.development?
    #require 'graphi_ql'
    #mount GraphiQL::Rails::Engine, at: '/graphiql', graphql_path: '/graphql'
  end
  post '/graphql', to: 'graphql#execute'

  root 'landing#index'
  get 'landing/index'

  # utilized to use vue-router history mode
  match '*path', to: redirect('/?redirect=%{path}'), via: :all

  devise_for :users
end
