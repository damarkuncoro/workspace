class CreateRoleRequests < ActiveRecord::Migration[8.1]
  def up
    create_table :role_requests, id: :uuid, default: -> { "gen_random_uuid()" } do |t|
      t.references :role, null: false, foreign_key: true, type: :uuid
      t.references :account, null: false, foreign_key: true, type: :uuid
      t.references :requested_by, null: false, foreign_key: { to_table: :accounts }, type: :uuid
      t.string :status, default: 'pending'
      t.text :comment
      t.datetime :requested_at, default: -> { "CURRENT_TIMESTAMP" }
      t.datetime :approved_at
      t.references :approved_by, foreign_key: { to_table: :accounts }, type: :uuid

      t.timestamps
    end

    add_index(:role_requests, [:account_id, :role_id, :status]) unless index_exists?(:role_requests, [:account_id, :role_id, :status])
    add_index(:role_requests, :requested_by_id) unless index_exists?(:role_requests, :requested_by_id)
    add_index(:role_requests, :approved_by_id) unless index_exists?(:role_requests, :approved_by_id)
  end

  def down
    drop_table :role_requests, if_exists: true
  end
end
