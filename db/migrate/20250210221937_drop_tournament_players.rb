class DropTournamentPlayers < ActiveRecord::Migration[8.0]
  def change
    drop_table :tournament_players
  end
end
