# frozen_string_literal: true

module Grille
  class User < Grille::Base
    include Devise::JWT::RevocationStrategies::JTIMatcher
    include Grille::Concerns::Tokenizable

    devise :database_authenticatable,
           :recoverable,
           :devise,
           :validatable,
           :trackable,
           :jwt_authenticatable,
           jwt_revocation_strategy: self

    validates :email, presence: true, uniqueness: true
    validates :email, length: { maximum: 255 }
    validates :email, format: { with: Devise.email_regexp }
    validates :first_name, presence: true
    validates :first_name, length: { maximum: 255 }
    validates :last_name, presence: true
    validates :last_name, length: { maximum: 255 }

    # Send mail through activejob
    def send_devise_notification(notification, *args)
      devise_mailer.send(notification, self, *args).deliver_later
    end

    # return first and lastname
    def name
      [first_name, last_name].join(' ').strip
    end

    # override to define specifc context actions
    class << self
      def delete(context:, params:)
        # should permissions be checked here on the model level?
        if params[:id].any? { |id| context[:current_user]&.id == id.to_i }
          raise 'cannot delete self'
        end

        super
      end
    end
  end
end
