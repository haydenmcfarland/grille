# frozen_string_literal: true

class Test < ApplicationRecord
  # FIXME: create a base class and create some dynamic fun to not have to add
  # so much boilerplate
  extend CRUDContext
end
