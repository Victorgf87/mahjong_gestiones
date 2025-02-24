class AddUserAssociationToPlayer < ActiveRecord::Migration[8.0]
  def change
    add_reference :players, :user, null: true, foreign_key: true, type: :uuid
  end
end
