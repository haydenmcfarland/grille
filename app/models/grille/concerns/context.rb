# frozen_string_literal: true

require 'active_support/concern'

module Grille
  module Concerns
    module Context
      extend ActiveSupport::Concern

      class_methods do
        def permission(context:)
          raise 'not a valid session' unless context[:current_user].present?
        end

        def create(context:, params: {})
          permission(context: context)
          create(params)
        end

        def read(context:, params: {})
          permission(context: context)
          where(params)
        end

        def update(context:, params:, update_params:)
          permission(context: context)
          where(params).update_all(update_params)
        end

        def delete(context:, params: {})
          permission(context: context)
          where(params).destroy_all
        end
      end
    end
  end
end
