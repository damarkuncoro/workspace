class AddConfigAndSchemaColumns < ActiveRecord::Migration[8.1]
  def change
    add_column :customer_devices, :config, :jsonb, default: {}, null: false
    add_column :customer_devices, :notes, :text
    add_column :device_types, :schema, :jsonb, default: {}, null: false
    add_column :devices, :default_config, :jsonb, default: {}, null: false
  end
end
