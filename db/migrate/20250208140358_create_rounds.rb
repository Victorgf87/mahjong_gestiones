class CreateRounds < ActiveRecord::Migration[8.0]
  def change
    create_table :rounds, id: :uuid do |t|
      t.references :tournament, null: false, foreign_key: true, type: :uuid
      t.integer :number, null: false
      t.datetime :start_at
      t.timestamps
    end
  end
end
