class CreateEmployees < ActiveRecord::Migration[7.1]
  def change
    create_table :employees, id: :uuid, default: -> { "gen_random_uuid()" } do |t|
      t.references :person, null: false, foreign_key: true, type: :uuid, index: { unique: true }
      t.string :employee_code, null: false, index: { unique: true }
      t.string :status, null: false, default: 'active'
      t.timestamps
    end

    # add_index :employees, :employee_code, unique: true
    # Tambahkan kondisi aman
    unless index_exists?(:employees, :employee_code)
      add_index :employees, :employee_code, unique: true
    end
  end
end
