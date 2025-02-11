class AddDescriptionToLeagues < ActiveRecord::Migration[8.0]
  def change
    add_column :leagues, :description, :text
  end
end
