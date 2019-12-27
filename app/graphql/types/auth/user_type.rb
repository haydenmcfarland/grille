# frozen_string_literal: true

module Types
  module Auth
    class UserType < ActiveRecordType
      class << self
        def model
          'User'
        end
      end
    end
  end
end
