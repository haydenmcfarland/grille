# frozen_string_literal: true

require 'graphql'

module Grille
  class Schema < GraphQL::Schema
    COMPONENTS_PATH = Pathname.new(
      File.join(__dir__, '../../../app/components/grille/components')
    )

    RAILS_APP_COMPONENTS_PATH = Rails.root.join('app/components')

    Dir[COMPONENTS_PATH + '**/*.rb'].sort.each { |f| require f }
    Dir[RAILS_APP_COMPONENTS_PATH + '**/*.rb'].sort.each { |f| require f }

    mutation(Types::MutationType)
    query(Types::QueryType)
  end
end
