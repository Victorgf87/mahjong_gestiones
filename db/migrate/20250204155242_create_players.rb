class CreatePlayers < ActiveRecord::Migration[8.0]
  def change
    create_table :players, id: :uuid do |t|
      t.string :name, null: false
      t.string :surname, null: false
      t.string :ema_number, null: false
      t.timestamps
    end
    add_index :players, :ema_number, unique: true
  end
end
