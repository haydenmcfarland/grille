# frozen_string_literal: true

module Grille
  module Configurable
    # overwrite to call component initialization
    def build; end

    def configure
      config = default_config
      yield(config)
      config.to_h.each { |k, v| send("#{k}=", v) }
      build
    end

    def default_config
      OpenStruct.new
    end
  end
end
