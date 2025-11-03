class CreateAccountRoles < ActiveRecord::Migration[8.1]
  def up
    create_table :account_roles, id: :uuid, default: -> { "gen_random_uuid()" } do |t|
      t.references :account, null: false, foreign_key: true, type: :uuid
      t.references :role, null: false, foreign_key: true, type: :uuid

      # Soft delete & Audit fields
      t.boolean :active, default: true, null: false
      t.datetime :assigned_at, default: -> { "CURRENT_TIMESTAMP" }
      t.datetime :revoked_at
      t.references :created_by, foreign_key: { to_table: :accounts }, type: :uuid
      t.references :revoked_by, foreign_key: { to_table: :accounts }, type: :uuid

      t.timestamps
    end

    add_index :account_roles, [ :account_id, :role_id ], unique: true
    unless index_exists?(:account_roles, :active)
      add_index :account_roles, :active
    end

    unless index_exists?(:account_roles, :revoked_by_id)
      add_index :account_roles, :revoked_by_id
    end
    
    unless index_exists?(:account_roles, :created_by_id)
      add_index :account_roles, :created_by_id
    end
    
  end


  def down
    # Drop table - this will automatically remove all associated indexes and foreign keys
    drop_table :account_roles, if_exists: true
  end

end
