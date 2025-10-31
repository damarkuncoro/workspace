class CreateCustomers < ActiveRecord::Migration[7.1]
  def change
    create_table :customers, id: :uuid, default: -> { "gen_random_uuid()" } do |t|
      t.references :person, null: false, foreign_key: true, type: :uuid, index: { unique: true }
      t.string :customer_code, null: false, index: { unique: true }
      t.string :status, null: false, default: 'active'
      t.timestamps
    end

    # add_index :customers, :customer_code, unique: true
    # Tambahkan kondisi aman
    unless index_exists?(:customers, :customer_code)
      add_index :customers, :customer_code, unique: true
    end
  end
end
