class AddScoringData < ActiveRecord::Migration[8.0]
  def change
    add_column :hands, :current_scores, :jsonb, default: []
    add_column :hands, :score_changes, :jsonb, default: []
    add_column :game_players, :score, :integer, default: 0
    add_column :game_players, :position, :integer, default: 0
    add_column :game_players, :position_weight, :integer, default: 0
  end
end
