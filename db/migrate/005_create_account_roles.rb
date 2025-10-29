class CreateAccountRoles < ActiveRecord::Migration[8.1]
  def change
    create_table :account_roles, id: :uuid, default: -> { "gen_random_uuid()" } do |t|
      t.references :account, null: false, foreign_key: true, type: :uuid
      t.references :role, null: false, foreign_key: true, type: :uuid
      t.timestamps
    end

    add_index :account_roles, [:account_id, :role_id], unique: true
  end
end
