# frozen_string_literal: true

class User < ApplicationRecord
  include GraphQL::Interface

  has_secure_password
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :database_authenticatable, :token_authenticatable

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
end
