# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2025_11_25_091500) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pgcrypto"

  create_table "account_roles", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "account_id", null: false
    t.boolean "active", default: true, null: false
    t.datetime "assigned_at", default: -> { "CURRENT_TIMESTAMP" }
    t.datetime "created_at", null: false
    t.uuid "created_by_id"
    t.datetime "revoked_at"
    t.uuid "revoked_by_id"
    t.uuid "role_id", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id", "role_id"], name: "index_account_roles_on_account_id_and_role_id", unique: true
    t.index ["account_id"], name: "index_account_roles_on_account_id"
    t.index ["active"], name: "index_account_roles_on_active"
    t.index ["created_by_id"], name: "index_account_roles_on_created_by_id"
    t.index ["revoked_by_id"], name: "index_account_roles_on_revoked_by_id"
    t.index ["role_id"], name: "index_account_roles_on_role_id"
  end

  create_table "accounts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_accounts_on_email", unique: true
    t.index ["reset_password_token"], name: "index_accounts_on_reset_password_token", unique: true
  end

  create_table "customer_devices", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.jsonb "config"
    t.datetime "created_at", null: false
    t.uuid "customer_id", null: false
    t.uuid "device_id", null: false
    t.text "notes"
    t.date "rented_from", null: false
    t.date "rented_until"
    t.string "status", default: "active", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id", "device_id"], name: "index_customer_devices_on_customer_id_and_device_id"
  end

  create_table "customer_phones", force: :cascade do |t|
  end

  create_table "customers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "customer_code", null: false
    t.uuid "person_id", null: false
    t.string "status", default: "active", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_code"], name: "index_customers_on_customer_code", unique: true
    t.index ["person_id"], name: "index_customers_on_person_id", unique: true
  end

  create_table "device_activities", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.uuid "customer_device_id", null: false
    t.jsonb "data", default: {}
    t.string "event_type", null: false
    t.datetime "recorded_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_device_id"], name: "index_device_activities_on_customer_device_id"
  end

  create_table "device_interfaces", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.uuid "device_id", null: false
    t.string "link_type"
    t.string "mac", null: false
    t.jsonb "metadata", default: {}
    t.string "name"
    t.datetime "updated_at", null: false
    t.index ["device_id"], name: "index_device_interfaces_on_device_id"
    t.index ["mac"], name: "index_device_interfaces_on_mac", unique: true
  end

  create_table "device_types", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_device_types_on_name", unique: true
  end

  create_table "devices", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.uuid "device_type_id", null: false
    t.string "firmware_version"
    t.string "label", null: false
    t.string "model"
    t.string "serial_number", null: false
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["device_type_id"], name: "index_devices_on_device_type_id"
    t.index ["serial_number"], name: "index_devices_on_serial_number", unique: true
    t.index ["status"], name: "index_devices_on_status"
  end

  create_table "employee_phones", force: :cascade do |t|
  end

  create_table "employees", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "employee_code", null: false
    t.uuid "person_id", null: false
    t.string "status", default: "active", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_code"], name: "index_employees_on_employee_code", unique: true
    t.index ["person_id"], name: "index_employees_on_person_id", unique: true
  end

  create_table "issue_activities", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "account_id"
    t.string "action", null: false
    t.datetime "created_at", null: false
    t.string "field_name"
    t.uuid "issue_id", null: false
    t.string "new_value"
    t.string "old_value"
    t.index ["account_id"], name: "index_issue_activities_on_account_id"
    t.index ["issue_id"], name: "index_issue_activities_on_issue_id"
  end

  create_table "issue_assignments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "account_id", null: false
    t.datetime "created_at", null: false
    t.uuid "issue_id", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_issue_assignments_on_account_id"
    t.index ["issue_id", "account_id"], name: "index_issue_assignments_on_issue_id_and_account_id", unique: true
    t.index ["issue_id"], name: "index_issue_assignments_on_issue_id"
  end

  create_table "issue_comments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "account_id", null: false
    t.text "content", null: false
    t.datetime "created_at", null: false
    t.boolean "internal", default: false
    t.uuid "issue_id", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_issue_comments_on_account_id"
    t.index ["issue_id"], name: "index_issue_comments_on_issue_id"
  end

  create_table "issues", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "assigned_to_id"
    t.datetime "created_at", null: false
    t.text "description"
    t.uuid "issueable_id"
    t.string "issueable_type"
    t.integer "priority", default: 1, null: false
    t.integer "status", default: 0, null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.index ["assigned_to_id"], name: "index_issues_on_assigned_to_id"
    t.index ["issueable_type", "issueable_id"], name: "index_issues_on_issueable"
  end

  create_table "link_connections", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.float "bandwidth_mbps"
    t.datetime "created_at", null: false
    t.uuid "device_interface_a_id", null: false
    t.uuid "device_interface_b_id", null: false
    t.float "latency_ms"
    t.string "link_type", default: "ethernet"
    t.jsonb "metadata", default: {}
    t.uuid "network_id"
    t.string "status", default: "up"
    t.datetime "updated_at", null: false
    t.index ["device_interface_a_id", "device_interface_b_id"], name: "index_link_connections_on_interfaces_pair", unique: true
  end

  create_table "network_activities", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.jsonb "data", default: {}
    t.uuid "device_id"
    t.uuid "device_interface_id"
    t.string "event_type", null: false
    t.uuid "network_id"
    t.datetime "recorded_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", null: false
    t.index ["device_id"], name: "index_network_activities_on_device_id"
    t.index ["network_id"], name: "index_network_activities_on_network_id"
    t.index ["recorded_at"], name: "index_network_activities_on_recorded_at"
  end

  create_table "network_devices", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "connected_at"
    t.datetime "created_at", null: false
    t.uuid "device_id", null: false
    t.uuid "device_interface_id"
    t.datetime "disconnected_at"
    t.inet "ip_address"
    t.jsonb "metadata", default: {}
    t.uuid "network_id", null: false
    t.string "status", default: "connected"
    t.datetime "updated_at", null: false
    t.index ["device_id"], name: "index_network_devices_on_device_id"
    t.index ["network_id", "device_id"], name: "index_network_devices_on_network_id_and_device_id", unique: true
    t.index ["network_id"], name: "index_network_devices_on_network_id"
  end

  create_table "networks", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.cidr "cidr"
    t.datetime "created_at", null: false
    t.string "kind", default: "lan", null: false
    t.string "location"
    t.jsonb "metadata", default: {}
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_networks_on_name", unique: true
  end

  create_table "people", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "account_id", null: false
    t.datetime "created_at", null: false
    t.date "date_of_birth"
    t.string "name"
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_people_on_account_id", unique: true
  end

  create_table "person_phones", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.boolean "is_owner", default: true, null: false
    t.jsonb "metadata", default: {}
    t.uuid "person_id", null: false
    t.uuid "phone_id", null: false
    t.datetime "updated_at", null: false
    t.index ["person_id", "phone_id"], name: "index_person_phones_on_person_id_and_phone_id", unique: true
  end

  create_table "phone_activities", force: :cascade do |t|
    t.datetime "activity_at", null: false
    t.string "activity_type", null: false
    t.string "call_direction"
    t.string "call_status"
    t.string "contact_name"
    t.string "contact_number", null: false
    t.datetime "created_at", null: false
    t.bigint "customer_phone_id", null: false
    t.integer "duration_seconds"
    t.text "message_content"
    t.jsonb "metadata", default: {}
    t.datetime "updated_at", null: false
    t.index ["activity_type", "activity_at"], name: "index_phone_activities_on_activity_type_and_activity_at"
    t.index ["customer_phone_id", "activity_at"], name: "index_phone_activities_on_customer_phone_id_and_activity_at", order: { activity_at: :desc }
    t.index ["customer_phone_id"], name: "index_phone_activities_on_customer_phone_id"
  end

  create_table "phones", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "role_requests", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "account_id", null: false
    t.datetime "approved_at"
    t.uuid "approved_by_id"
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "requested_at", default: -> { "CURRENT_TIMESTAMP" }
    t.uuid "requested_by_id", null: false
    t.uuid "role_id", null: false
    t.string "status", default: "pending"
    t.datetime "updated_at", null: false
    t.index ["account_id", "role_id", "status"], name: "index_role_requests_on_account_id_and_role_id_and_status"
    t.index ["account_id"], name: "index_role_requests_on_account_id"
    t.index ["approved_by_id"], name: "index_role_requests_on_approved_by_id"
    t.index ["requested_by_id"], name: "index_role_requests_on_requested_by_id"
    t.index ["role_id"], name: "index_role_requests_on_role_id"
  end

  create_table "roles", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "account_roles", "accounts"
  add_foreign_key "account_roles", "accounts", column: "created_by_id"
  add_foreign_key "account_roles", "accounts", column: "revoked_by_id"
  add_foreign_key "account_roles", "roles"
  add_foreign_key "customers", "people"
  add_foreign_key "devices", "device_types"
  add_foreign_key "employees", "people"
  add_foreign_key "issue_assignments", "accounts"
  add_foreign_key "issue_assignments", "issues"
  add_foreign_key "issues", "accounts", column: "assigned_to_id", on_delete: :nullify
  add_foreign_key "link_connections", "device_interfaces", column: "device_interface_a_id"
  add_foreign_key "link_connections", "device_interfaces", column: "device_interface_b_id"
  add_foreign_key "link_connections", "networks"
  add_foreign_key "people", "accounts"
  add_foreign_key "person_phones", "phones"
  add_foreign_key "role_requests", "accounts"
  add_foreign_key "role_requests", "accounts", column: "approved_by_id"
  add_foreign_key "role_requests", "accounts", column: "requested_by_id"
  add_foreign_key "role_requests", "roles"
end
