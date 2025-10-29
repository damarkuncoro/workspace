class CreatePeople < ActiveRecord::Migration[8.1]
  def change
    create_table :people, id: :uuid, default: -> { "gen_random_uuid()" } do |t|
      t.references :account, null: false, foreign_key: true, type: :uuid, index: { unique: true }
      t.string :name
      t.date :date_of_birth

      t.timestamps
    end
  end
end