class CreateTest < ActiveRecord::Migration[6.0]
  def change
    create_table :tests do |t|
      t.string :name, null: false
      t.integer :age, null: true
      t.jsonb :details, default: {}
      t.timestamps
    end
  end
end
