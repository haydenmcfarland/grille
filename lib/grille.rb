# frozen_string_literal: true

require 'grille/engine'
require 'webpacker'

module Grille
  ROOT_PATH = Pathname.new(File.join(__dir__, '..'))

  class << self
    attr_accessor :configuration
    def webpacker
      @webpacker ||= ::Webpacker::Instance.new(
        root_path: ROOT_PATH,
        config_path: ROOT_PATH.join('config', 'webpacker.yml')
      )
    end
  end
end
