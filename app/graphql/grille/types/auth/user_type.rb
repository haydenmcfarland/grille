# frozen_string_literal: true

module Grille
  module Types
    module Auth
      class UserType < Grille::Types::ActiveRecordType
        configure do |c|
          c.model = 'User'
        end
      end
    end
  end
end
