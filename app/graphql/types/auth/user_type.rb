# frozen_string_literal: true

module Types
  module Auth
    class UserType < ActiveRecordType
      configure do |c|
        c.model = 'User'
      end
    end
  end
end
