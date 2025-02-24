class CreateEventPlayers < ActiveRecord::Migration[8.0]
  def change
    create_table :event_players, id: :uuid do |t|
      t.references :player, null: false, foreign_key: true, type: :uuid
      t.references :eventable, polymorphic: true, null: false, type: :uuid

      t.timestamps
    end

    def change
      remove_reference :players, :tournament, foreign_key: true
    end
  end
end
