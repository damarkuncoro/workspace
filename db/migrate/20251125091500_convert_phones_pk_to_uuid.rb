class ConvertPhonesPkToUuid < ActiveRecord::Migration[8.1]
  # Migrasi: Konversi primary key tabel phones dari bigint ke UUID
  # Alasan: Menyamakan tipe kolom dengan person_phones.phone_id (UUID) untuk mencegah error join bigint ↔ uuid
  # Catatan: Down migration dibuat irreversible untuk menjaga konsistensi data

  def up
    enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')

    # Tambahkan kolom UUID baru sebagai kandidat primary key
    add_column :phones, :id_new, :uuid, default: -> { "gen_random_uuid()" }, null: false

    # Lepas FK lama ke phones (jika ada), agar bisa ganti PK tanpa konflik
    begin
      remove_foreign_key :person_phones, :phones
    rescue StandardError
      # FK mungkin belum ada atau berbeda nama, abaikan bila gagal
    end

    # Ganti primary key ke kolom UUID baru
    execute "ALTER TABLE phones DROP CONSTRAINT phones_pkey"
    execute "ALTER TABLE phones ADD CONSTRAINT phones_pkey PRIMARY KEY (id_new)"

    # Rename kolom id lama ke id_old, dan id_new menjadi id
    rename_column :phones, :id, :id_old
    rename_column :phones, :id_new, :id

    # Tambahkan kembali FK person_phones → phones menggunakan kolom UUID baru
    add_foreign_key :person_phones, :phones, column: :phone_id, primary_key: :id

    # Bersihkan kolom id_old agar skema final rapi
    remove_column :phones, :id_old, :bigint
  end

  def down
    # Perubahan ini tidak dapat dikembalikan dengan aman karena mengubah tipe primary key.
    raise ActiveRecord::IrreversibleMigration, "Konversi phones.id ke UUID tidak dapat di-rollback dengan aman"
  end
end

