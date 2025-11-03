class CreateDevices < ActiveRecord::Migration[8.1]
  def change
    create_table :devices, id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
      t.references :device_type, type: :uuid, null: false, foreign_key: true
      t.string :label, null: false
      t.string :serial_number, null: false
      t.string :model
      t.string :firmware_version
      t.integer :status, default: 0, null: false

      t.timestamps
    end

    add_index :devices, :serial_number, unique: true
    add_index :devices, :status
  end
end
