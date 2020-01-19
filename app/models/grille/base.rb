# frozen_string_literal: true

module Grille
  # base class for adding graphql context to models
  class Base < ApplicationRecord
    self.abstract_class = true
    include Grille::Concerns::Context
  end
end
