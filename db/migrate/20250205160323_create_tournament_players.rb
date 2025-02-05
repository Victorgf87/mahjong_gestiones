class CreateTournamentPlayers < ActiveRecord::Migration[8.0]
  def change
    create_table :tournament_players, id: :uuid do |t|
      t.references :tournament, null: false, foreign_key: true, type: :uuid
      t.references :player, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
