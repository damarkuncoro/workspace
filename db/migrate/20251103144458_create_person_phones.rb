class CreatePersonPhones < ActiveRecord::Migration[8.1]
  def change
    # Create person_phones join table
    create_table :person_phones, id: :uuid, default: -> { "gen_random_uuid()" } do |t|
      t.uuid :person_id, null: false
      t.uuid :phone_id, null: false
      t.boolean :is_owner, default: true, null: false
      t.jsonb :metadata, default: {}
      t.timestamps
      t.index [:person_id, :phone_id], unique: true

    end
 # Add foreign keys
    add_foreign_key :person_phones, :people
    add_foreign_key :person_phones, :phones
  end
end
