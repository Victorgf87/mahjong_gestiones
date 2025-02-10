class CreateLeagues < ActiveRecord::Migration[8.0]
  def change
    create_table :leagues, id: :uuid do |t|
      t.timestamps
      t.string :name, null: false
      t.datetime :start_date
      t.datetime :end_date
      t.references :creator, foreign_key: { to_table: :users }, type: :uuid, null: false
    end
    add_index :leagues, :name, unique: true
  end
end
