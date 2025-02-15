class AddPositionToGamePlayer < ActiveRecord::Migration[8.0]
  def change
    add_column :game_players, :seat, :integer, default: -1
  end
end
