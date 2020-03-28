# frozen_string_literal: true

Grille::Engine.routes.draw do
  post '/graphql', to: 'graphql#execute'

  root 'landing#index'
  get 'landing/index'

  # utilized to use vue-router history mode
  get ':path', to: redirect('/?redirect=%{path}'), constraints: {
    path: /((?!graphiql).)*/
  }

  if ENV['GRILLE_GRAPHI_QL'] == 'true' && Rails.env.development?
    require 'graphiql/rails'
    mount GraphiQL::Rails::Engine, at: '/graphiql', graphql_path: '/graphql'
  end

  devise_for :users, class_name: 'Grille::User', module: :devise
end
