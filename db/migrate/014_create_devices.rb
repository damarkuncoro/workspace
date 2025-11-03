class CreateDevices < ActiveRecord::Migration[8.1]
  def change
    create_table :devices, id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
      t.uuid "device_type_id", null: false
      t.string "name", null: false
      t.string "serial_number", null: false
      t.string "status", default: "available", null: false
      t.jsonb "default_config", default: {}
      t.timestamps
    end

    add_index :devices, [:device_type_id]
    add_index :devices, [:serial_number], unique: true
  end
end
