class CreatePhones < ActiveRecord::Migration[8.1]
  def change
    
      create_table :phones, id: :uuid, default: -> { "gen_random_uuid()" } do |t|
      t.string :phone_number, null: false
      t.string :phone_type, default: "mobile", null: false
      t.boolean :is_primary, default: false, null: false
      t.jsonb :metadata, default: {}
      t.timestamps
      t.index :phone_number, unique: true
    end

  end
end
