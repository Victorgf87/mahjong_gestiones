class CreateGames < ActiveRecord::Migration[8.0]
  def change
    create_table :games, id: :uuid do |t|
      t.references :tournament, null: false, foreign_key: true, type: :uuid
      t.integer :round
      t.integer :table
      t.timestamps
    end
  end
end
