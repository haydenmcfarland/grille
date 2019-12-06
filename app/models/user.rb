# frozen_string_literal: true

class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
  include Tokenizable

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :devise,
         :validatable,
         :trackable,
         :jwt_authenticatable,
         jwt_revocation_strategy: self

  # - VALIDATIONS
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
end
