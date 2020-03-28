# frozen_string_literal: true

Grille::Engine.routes.draw do
  post '/graphql', to: 'graphql#execute'

  root 'landing#index'
  get 'landing/index'

  path_constraints = {}
  if Rails.env.development?
    if ENV['GRILLE_GRAPHI_QL'] == 'true'
      require 'graphiql/rails'
      mount GraphiQL::Rails::Engine, at: '/graphiql', graphql_path: '/graphql'
      path_constraints[:path] = /((?!graphiql).)*/
    end
  end

  # utilized to use vue-router history mode
  get ':path', to: redirect('/?redirect=%{path}'), constraints: path_constraints

  devise_for :users, class_name: 'Grille::User', module: :devise
end
