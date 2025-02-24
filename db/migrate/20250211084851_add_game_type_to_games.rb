class AddGameTypeToGames < ActiveRecord::Migration[8.0]
  def change
    add_column :games, :game_type, :integer, default: 0
    add_column :games, :rated, :boolean, default: true
  end
end
