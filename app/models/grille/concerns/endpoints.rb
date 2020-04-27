# frozen_string_literal: true

require 'graphql'

module Grille
  module Concerns
    module Endpoints
      extend ActiveSupport::Concern

      module_function

      def included(klass)
        klass.define_singleton_method(:endpoint) do |name|
          endpoint = Class.new(Grille::Mutations::Base) do
            argument :params, String, required: true
            field :result, String, null: true

            def grille_resolver(params:)
              yield(JSON.parse(params))
            end
          end

          endpoint_name = name.to_s.camelize
          endpoint_klass = Object.const_set(endpoint_name, endpoint)
          Grille::Types::MutationType.field(
            endpoint_name,
            mutation: endpoint_klass
          )
        end
      end
    end
  end
end
