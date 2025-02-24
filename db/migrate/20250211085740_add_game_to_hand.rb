class AddGameToHand < ActiveRecord::Migration[8.0]
  def change
    add_reference :hands, :game, null: false, foreign_key: true, type: :uuid
    add_column :games, :status, :integer, default: 0
  end
end
