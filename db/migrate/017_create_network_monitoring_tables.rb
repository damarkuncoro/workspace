class CreateNetworkMonitoringTables < ActiveRecord::Migration[8.1]
  def change
    create_table :networks, id: :uuid, default: -> { "gen_random_uuid()" } do |t|
      t.string :name, null: false
      t.string :kind, null: false, default: "lan" # lan, wifi, vpn, wan
      t.cidr   :cidr # requires extension inet or use string if unsupported
      t.string :location
      t.jsonb  :metadata, default: {}
      t.timestamps
    end
    add_index :networks, :name, unique: true

    create_table :device_interfaces, id: :uuid, default: -> { "gen_random_uuid()" } do |t|
      t.uuid   :device_id, null: false
      t.string :name # eth0, wlan0, radio0
      t.string :mac, null: false
      t.string :link_type # ethernet/wifi/virtual
      t.jsonb  :metadata, default: {}
      t.timestamps
    end
    add_index :device_interfaces, [:device_id]
    add_index :device_interfaces, [:mac], unique: true

    create_table :network_devices, id: :uuid, default: -> { "gen_random_uuid()" } do |t|
      t.uuid   :network_id, null: false
      t.uuid   :device_id, null: false
      t.uuid   :device_interface_id
      t.inet   :ip_address
      t.string :status, default: "connected" # connected, disconnected
      t.datetime :connected_at
      t.datetime :disconnected_at
      t.jsonb  :metadata, default: {}
      t.timestamps
    end
    add_index :network_devices, [:network_id]
    add_index :network_devices, [:device_id]
    add_index :network_devices, [:network_id, :device_id], unique: true

    create_table :network_activities, id: :uuid, default: -> { "gen_random_uuid()" } do |t|
      t.uuid :network_id
      t.uuid :device_id
      t.uuid :device_interface_id
      t.string :event_type, null: false # dhcp_assigned, link_up, link_down, ip_change, auth_fail, rssi
      t.jsonb :data, default: {}
      t.datetime :recorded_at, null: false, default: -> { "CURRENT_TIMESTAMP" }
      t.timestamps
    end
    add_index :network_activities, [:network_id]
    add_index :network_activities, [:device_id]
    add_index :network_activities, :recorded_at
  end
end