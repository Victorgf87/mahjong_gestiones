class AddRoundsAmountToTournament < ActiveRecord::Migration[8.0]
  def change
    rename_column :tournaments, :rounds, :round_amount
  end
end
