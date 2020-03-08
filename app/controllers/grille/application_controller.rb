# frozen_string_literal: true

module Grille
  class ApplicationController < ActionController::Base
    protect_from_forgery with: :null_session

    private

    def not_authorized
      render json: { error: 'Not authorized' }, status: :unauthorized
    end
  end
end
