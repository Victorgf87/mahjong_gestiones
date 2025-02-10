class CreateTournaments < ActiveRecord::Migration[8.0]
  def change
    create_table :tournaments, id: :uuid do |t|
      t.string :name, null: false
      t.datetime :start_date
      t.datetime :end_date
      t.string :location_name
      t.string :location_address
      t.references :creator, foreign_key: { to_table: :users }, type: :uuid, null: false
      t.timestamps
    end
    add_index :tournaments, :name, unique: true
  end
end
