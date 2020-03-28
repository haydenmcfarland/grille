# frozen_string_literal: true

module Grille
  module Configurable
    # should return a hash or an object that supports to_h
    def default_config; end

    def configure
      config = default_config
      yield(config)
      config.to_h.each { |k, v| send("#{k}=", v) }
      build
    end

    def build; end
  end
end
