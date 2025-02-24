class AddIndexToPosition < ActiveRecord::Migration[8.0]
  def change
    add_index :hands, :position
  end
end
