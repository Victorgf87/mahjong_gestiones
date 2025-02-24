class CreateImages < ActiveRecord::Migration[8.0]
  def change
    create_table :images, id: :uuid do |t|
      t.string :url
      t.references :imageable, polymorphic: true, null: false, type: :uuid
      # t.boolean :cover



      t.timestamps
    end
    add_column :images, :image_type, :integer, default: 0
  end
end
