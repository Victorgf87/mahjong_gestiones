class AddTournamentStatus < ActiveRecord::Migration[8.0]
  def change
    add_column :tournaments, :status, :integer, default: 0, null: false
  end
end
