# frozen_string_literal: true

class CreateTest < ActiveRecord::Migration[6.0]
  def change
    create_table :grille_tests do |t|
      t.string :name, null: false
      t.integer :age, null: true
      t.jsonb :details, default: {}
      t.timestamps
    end
  end
end
