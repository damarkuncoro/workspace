class CreateLinkConnections < ActiveRecord::Migration[8.1]
  def change
    create_table :link_connections, id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
      # Titik koneksi pertama
      t.uuid :device_interface_a_id, null: false
      # Titik koneksi kedua
      t.uuid :device_interface_b_id, null: false

      # Metadata tambahan
      t.uuid :network_id                    # Opsional, untuk koneksi di jaringan tertentu
      t.string :link_type, default: "ethernet"  # ethernet, fiber, wireless, vpn, dll
      t.string :status, default: "up"       # up, down, testing, error
      t.float :bandwidth_mbps               # kecepatan link
      t.float :latency_ms                   # waktu tunda rata-rata
      t.jsonb :metadata, default: {}        # data tambahan seperti kabel ID, port speed, dll

      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false

      # Index dan constraint
      t.index [:device_interface_a_id, :device_interface_b_id],
              name: "index_link_connections_on_interfaces_pair", unique: true
    end

    add_foreign_key :link_connections, :device_interfaces, column: :device_interface_a_id
    add_foreign_key :link_connections, :device_interfaces, column: :device_interface_b_id
    add_foreign_key :link_connections, :networks
  end
end