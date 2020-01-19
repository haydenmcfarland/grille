# frozen_string_literal: true

module Grille
  class ApplicationController < ActionController::Base
    # include JWTSessions::RailsAuthorization
    # rescue_from JWTSessions::Errors::Unauthorized, with: :not_authorized

    protect_from_forgery with: :null_session

    private

    def not_authorized
      render json: { error: 'Not authorized' }, status: :unauthorized
    end
  end
end
