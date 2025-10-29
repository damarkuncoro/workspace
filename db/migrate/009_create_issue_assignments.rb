# db/migrate/20251028xxxxxx_create_issue_assignments.rb
class CreateIssueAssignments < ActiveRecord::Migration[8.1]
  def change
    create_table :issue_assignments, id: :uuid, default: -> { "gen_random_uuid()" } do |t|
      t.references :issue, null: false, type: :uuid, foreign_key: true
      t.references :account, null: false, type: :uuid, foreign_key: true

      t.timestamps
    end

    # Unique index untuk mencegah duplikasi
    add_index :issue_assignments, [:issue_id, :account_id], unique: true unless index_exists?(:issue_assignments, [:issue_id, :account_id])
  end
end
