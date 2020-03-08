# frozen_string_literal: true

class DeviseCreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :grille_users do |t|
      ## General
      t.string   'first_name',     null: false, default: ''
      t.string   'last_name',      null: false, default: ''

      ## Database authenticatable
      t.string :email,              null: false, default: ''
      t.string :encrypted_password, null: false, default: ''

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      # t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.inet     :current_sign_in_ip
      t.inet     :last_sign_in_ip

      ## Confirmable
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email

      # Lockable
      t.integer  :failed_attempts, default: 0, null: false
      t.string   :unlock_token
      t.datetime :locked_at

      ## JTI for JWT auth
      t.string   'jti', null: false

      t.timestamps null: false
    end

    add_index :grille_users, :email,                unique: true
    add_index :grille_users, :reset_password_token, unique: true
    add_index :grille_users, :confirmation_token,   unique: true
    add_index :grille_users, :unlock_token,         unique: true
    add_index 'grille_users', ['jti'], name: 'index_users_on_jti', unique: true,
                                       using: :btree
  end
end
