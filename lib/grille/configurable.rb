# frozen_string_literal: true

module Grille
  module Configurable
    # overwrite to call component initialization
    def build; end

    def default_config; end

    def configure
      config = OpenStruct.new(default_config)
      yield(config)
      config.to_h.each { |k, v| send("#{k}=", v) }
      build
    end
  end
end
