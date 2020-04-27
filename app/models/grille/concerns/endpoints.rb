# frozen_string_literal: true

require 'graphql'

module Grille
  module Concerns
    module Endpoints
      extend ActiveSupport::Concern

      module_function

      def included(klass)
        klass.define_singleton_method(:endpoint) do |name, &block|
          endpoint = Class.new(Grille::Mutations::Base) do
            argument :params, String, required: true
            field :result, String, null: true
          end

          endpoint.define_method(:grille_resolver) do |**args|
            arg = begin
                    JSON.parse(args[:params])
                  rescue StandardError
                    args[:params]
                  end

            block.call(arg)
          end

          endpoint_name = name.to_s.camelize
          endpoint_klass = Object.const_set(endpoint_name, endpoint)

          Grille::Types::MutationType.field(
            name.to_sym,
            mutation: endpoint_klass
          )
        end
      end
    end
  end
end
