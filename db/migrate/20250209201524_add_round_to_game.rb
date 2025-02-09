class AddRoundToGame < ActiveRecord::Migration[8.0]
  def change
    add_reference :games, :round, null: true, foreign_key: true, type: :uuid
  end
end
