class RemoveUniquenessFromEmaNumber < ActiveRecord::Migration[8.0]
  def change
    remove_index :players, :ema_number
    add_index :players, :ema_number
  end
end
