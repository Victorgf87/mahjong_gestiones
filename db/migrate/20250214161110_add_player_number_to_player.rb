class AddPlayerNumberToPlayer < ActiveRecord::Migration[8.0]
  def change
    add_column :players, :player_number, :integer, default: 0, null: false


    # Player.all.each_with_index{|player, index| player.update(player_number: index + 1)}
    # execute "CREATE SEQUENCE players_player_number_sequence START 1001"
  end
end
