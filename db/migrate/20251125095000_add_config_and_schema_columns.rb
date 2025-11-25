class AddConfigAndSchemaColumns < ActiveRecord::Migration[8.1]
  # Menambahkan kolom konfigurasi untuk beberapa tabel.
  # Idempoten: hanya menambah kolom bila belum ada.
  # Prinsip: KISS/DRY — hindari error duplicate column saat migrasi ulang.
  def up
    add_column :customer_devices, :config, :jsonb, default: {}, null: false unless column_exists?(:customer_devices, :config)
    add_column :customer_devices, :notes, :text unless column_exists?(:customer_devices, :notes)
    add_column :device_types, :schema, :jsonb, default: {}, null: false unless column_exists?(:device_types, :schema)
    add_column :devices, :default_config, :jsonb, default: {}, null: false unless column_exists?(:devices, :default_config)
  end

  # Penghapusan kolom bersifat destruktif; lakukan hanya jika ada.
  # Catatan: Jika ada data di kolom ini, penghapusan akan menghilangkan data tersebut.
  def down
    remove_column :customer_devices, :config if column_exists?(:customer_devices, :config)
    remove_column :customer_devices, :notes if column_exists?(:customer_devices, :notes)
    remove_column :device_types, :schema if column_exists?(:device_types, :schema)
    remove_column :devices, :default_config if column_exists?(:devices, :default_config)
  end
end
