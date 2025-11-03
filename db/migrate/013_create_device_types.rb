class CreateDeviceTypes < ActiveRecord::Migration[8.1]
  def change
    create_table :device_types, id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
      t.string "name", null: false
      t.string "manufacturer"
      t.jsonb "schema", default: {}
      t.text "description"
      t.timestamps
    end

    add_index :device_types, [:name], unique: true
  end
end
