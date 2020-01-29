require "webpacker/helper"

module Grille
  module ApplicationHelper
    include ::Webpacker::Helper

    def current_webpacker_instance
      Grille.webpacker
    end
  end
end
