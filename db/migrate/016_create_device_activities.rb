class CreateDeviceActivities < ActiveRecord::Migration[8.1]
  def change
    create_table :device_activities, id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
      t.uuid "customer_device_id", null: false
      t.string "event_type", null: false
      t.jsonb "data", default: {}
      t.datetime "recorded_at", null: false
      t.timestamps
    end

    add_index :device_activities, [:customer_device_id]
  end
end
