class CreateHands < ActiveRecord::Migration[8.0]
  def change
    create_table :hands, id: :uuid do |t|
      t.references :winner, foreign_key: {to_table: :players}, type: :uuid, null: false
      t.references :loser, foreign_key: {to_table: :players}, type: :uuid, null: false
      t.integer :points, null: false

      t.timestamps
    end
  end
end
