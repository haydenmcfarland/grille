# frozen_string_literal: true

module Grille
  module Configurable
    def default_config
      OpenStruct.new
    end

    def configure
      config = default_config
      yield(config)
      config.to_h.each { |k, v| send("#{k}=", v) }
      build
    end

    def build; end
  end
end
