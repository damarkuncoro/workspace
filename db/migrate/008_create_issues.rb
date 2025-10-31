class CreateIssues < ActiveRecord::Migration[8.1]
  def up
    create_table :issues, id: :uuid, default: -> { "gen_random_uuid()" } do |t|
      t.string :title, null: false
      t.text :description
      # Gunakan integer agar sesuai enum default
      t.integer :status, null: false, default: 0
      t.integer :priority, null: false, default: 1

      t.uuid :issueable_id
      t.string :issueable_type
      t.uuid :assigned_to_id

      t.timestamps
    end

    add_index :issues, [ :issueable_type, :issueable_id ], name: "index_issues_on_issueable" unless index_exists?(:issues, [ :issueable_type, :issueable_id ])
    add_index :issues, :assigned_to_id unless index_exists?(:issues, :assigned_to_id)

    add_foreign_key :issues, :accounts, column: :assigned_to_id, on_delete: :nullify
  end

  def down
    # Hapus foreign key dulu, tapi cek dulu ada/tidak
    remove_foreign_key :issues, column: :assigned_to_id if foreign_key_exists?(:issues, column: :assigned_to_id)

    # Hapus index kalau ada
    remove_index :issues, name: "index_issues_on_issueable" if index_exists?(:issues, name: "index_issues_on_issueable")
    remove_index :issues, :assigned_to_id if index_exists?(:issues, :assigned_to_id)

    # Drop table
    drop_table :issues
  end
end
