class ModifyScoreWeight < ActiveRecord::Migration[8.0]
  def change
    change_column :game_players, :position_weight, :float
  end
end
