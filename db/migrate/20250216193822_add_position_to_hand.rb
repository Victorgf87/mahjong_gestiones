class AddPositionToHand < ActiveRecord::Migration[8.0]
  def change
    add_column :hands, :position, :integer
  end
end
