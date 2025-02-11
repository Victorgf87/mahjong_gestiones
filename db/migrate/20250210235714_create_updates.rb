class CreateUpdates < ActiveRecord::Migration[8.0]
  def change
    create_table :updates, id: :uuid do |t|
      t.text :content
      t.text :title
      t.references :updatable, polymorphic: true, null: false, type: :uuid

      t.timestamps
    end
  end
end
