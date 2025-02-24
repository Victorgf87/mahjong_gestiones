class CreateGamePlayers < ActiveRecord::Migration[8.0]
  def change
    create_table :game_players, id: :uuid do |t|
      t.references :player, null: false, foreign_key: true, type: :uuid
      t.references :game, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
