class AddGameToHandAgain < ActiveRecord::Migration[8.0]
  def change
    Hand.delete_all
    add_reference :hands, :game, null: false, foreign_key: true, type: :uuid
  end
end
