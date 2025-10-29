class CreateIssueComments < ActiveRecord::Migration[7.0]
  def change
    create_table "issue_comments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
      t.uuid "issue_id", null: false
      t.uuid "account_id", null: false        # siapa yang menulis komentar
      t.text "content", null: false
      t.boolean "internal", default: false    # true jika hanya untuk tim internal
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end
  
  add_index "issue_comments", ["issue_id"], name: "index_issue_comments_on_issue_id"
  add_index "issue_comments", ["account_id"], name: "index_issue_comments_on_account_id"
  end
end
