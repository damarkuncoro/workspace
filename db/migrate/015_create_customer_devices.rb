class CreateCustomerDevices < ActiveRecord::Migration[8.1]
  def change
    create_table :customer_devices, id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
      t.uuid "customer_id", null: false
      t.uuid "device_id", null: false
      t.date "rented_from", null: false
      t.date "rented_until"
      t.string "status", default: "active", null: false
      t.jsonb "config", default: {}
      t.timestamps
    end

    add_index :customer_devices, [:customer_id, :device_id], unique: true
  end
end
