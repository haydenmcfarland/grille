# frozen_string_literal: true

Rails.application.routes.draw do
  if Rails.env.development?
    mount GraphiQL::Rails::Engine, at: '/graphiql', graphql_path: '/graphql'
  end
  post '/graphql', to: 'graphql#execute'
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
  match /^(graphql)/, to: redirect('/?redirect=%{path}'), via: :all
end
