class AddEventToGames < ActiveRecord::Migration[8.0]
  def change
    remove_reference :games, :tournament, foreign_key: true
    add_reference :games, :event, polymorphic: true, index: true
  end
end
