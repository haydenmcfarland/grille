# frozen_string_literal: true

require 'grille/engine'
require 'webpacker'

module Grille
  ROOT_PATH = Pathname.new(File.join(__dir__, '..'))
  FULL_GEM_PATH = Gem.loaded_specs['grille'].full_gem_path

  class << self
    attr_accessor :configuration
    def webpacker
      @webpacker ||= ::Webpacker::Instance.new(
        root_path: ROOT_PATH,
        config_path: ROOT_PATH.join('config', 'webpacker.yml')
      )
    end

    def javascript(path)
      File.join(ROOT_PATH, 'app/javascript/', path)
    end
  end
end
