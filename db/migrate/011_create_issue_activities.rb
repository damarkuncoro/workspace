class CreateIssueActivities < ActiveRecord::Migration[7.0]
  def change
    create_table "issue_activities", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
      t.uuid "issue_id", null: false
      t.uuid "account_id"                      # siapa yang melakukan aksi
      t.string "action", null: false           # jenis aksi: "status_changed", "priority_changed", "comment_added", dll
      t.string "field_name"                    # nama kolom yang berubah (opsional)
      t.string "old_value"
      t.string "new_value"
      t.datetime "created_at", null: false
    end
    add_index "issue_activities", ["issue_id"], name: "index_issue_activities_on_issue_id"
    add_index "issue_activities", ["account_id"], name: "index_issue_activities_on_account_id"
  end
end
