# frozen_string_literal: true

module Grille
  module GraphQL
    # base class for adding graphql context to models
    class Base < ApplicationRecord
      self.abstract_class = true
      extend Grille::GraphQL::ModelContext
    end
  end
end
