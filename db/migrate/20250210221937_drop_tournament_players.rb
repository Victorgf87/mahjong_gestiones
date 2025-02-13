class DropTournamentPlayers < ActiveRecord::Migration[8.0]
  def change
    drop_table :tournament_players, if_exists: true
  end
end
