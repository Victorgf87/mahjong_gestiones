class CreatePhotos < ActiveRecord::Migration[8.0]
  def change
    create_table :photos, id: :uuid do |t|
      t.references :imageable, polymorphic: true, null: false, type: :uuid
      t.string :file_key

      t.timestamps
    end
  end
end
