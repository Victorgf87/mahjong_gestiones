class ChangeEventIdToUuid < ActiveRecord::Migration[8.0]

  def up
    # Añadir una nueva columna UUID
    add_column :games, :new_event_id, :uuid, default: "gen_random_uuid()"

    # Actualizar la nueva columna con UUIDs únicos
    execute "UPDATE games SET new_event_id = gen_random_uuid()"

    # Eliminar la columna integer original
    remove_column :games, :event_id

    # Renombrar la nueva columna UUID
    rename_column :games, :new_event_id, :event_id

    # Establecer la nueva columna como clave primaria si es necesario
    # execute "ALTER TABLE games ADD PRIMARY KEY (event_id)"

    add_index :games, :event_id
  end

  def down
    # Revertir los cambios si es necesario
    change_column :games, :event_id, :integer
  end
end

