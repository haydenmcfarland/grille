# frozen_string_literal: true

module Grille
  module Mutations
    module Auth
      class << self
        def user_to_hash(user)
          user.as_json.slice('email', 'id').merge('token' => user.token)
        end
      end
    end
  end
end
