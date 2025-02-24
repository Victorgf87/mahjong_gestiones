class AddRoundsToTournament < ActiveRecord::Migration[8.0]
  def change
    add_column :tournaments, :rounds, :integer, default: 0
  end
end
